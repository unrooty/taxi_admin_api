Sequel.migration do
  up do
    alter_table :users do
      add_column :refresh_tokens, :jsonb, default: {}.to_json
    end

    run "CREATE OR REPLACE FUNCTION check_token_not_exist(token jsonb, OUT result text) as

    $BODY$
    BEGIN

      IF EXISTS(SELECT 1 FROM users WHERE (
                SELECT ARRAY(
                SELECT * FROM jsonb_object_keys(refresh_tokens))) @> (
                SELECT ARRAY(
                SELECT * FROM jsonb_object_keys(token))) AND NOT (
                '{}' = ANY (
                SELECT ARRAY(SELECT * FROM jsonb_object_keys(token))))) THEN

      result := 'false';

      ELSE

      result := 'true';
      END IF;

      RETURN;
      END
        $BODY$ language plpgsql; "
    run "ALTER TABLE users
    ADD CONSTRAINT check_token
    CHECK (check_token_not_exist(refresh_tokens) = 'true')"

  end
  down do
    alter_table :users do
      drop_column :refresh_tokens
    end
    run 'DROP FUNCTION public.check_token_not_exist(jsonb);'
  end
end
