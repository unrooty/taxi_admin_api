Sequel.migration do
  up do
    run "ALTER TABLE users
         ADD CONSTRAINT check_roles
         CHECK ((role = 'Admin') OR
                (role = 'Client') OR
                (role = 'Dispatcher') OR
                (role = 'Driver') OR
                (role = 'Manager') OR
                (role = 'Accountant'))"
  end

  down do
    alter_table :users do
      drop_constraint :check_roles
    end
  end
end
