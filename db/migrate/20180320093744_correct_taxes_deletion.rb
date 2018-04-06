Sequel.migration do
  up do
    run "CREATE OR REPLACE FUNCTION public.check_if_tax_not_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF (SELECT by_default FROM taxes WHERE id = OLD.id) = true THEN

    RAISE EXCEPTION 'Can not delete default tax';

  END IF;

  IF ((SELECT COUNT(*) FROM orders WHERE tax_id = OLD.id) >= 1) THEN

    RAISE EXCEPTION 'Tax can not be deleted. One or more orders are associated to this tax.';

  END IF;

  RETURN OLD;

END
$$;"
  end

  down do
    run "CREATE OR REPLACE FUNCTION public.check_if_tax_not_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  IF (SELECT by_default FROM taxes WHERE id = OLD.id) = true THEN

    RAISE EXCEPTION 'cannot delete default tax';

  END IF;

  RETURN OLD;

END
$$;"
  end
end
