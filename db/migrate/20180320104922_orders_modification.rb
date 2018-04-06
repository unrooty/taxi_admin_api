Sequel.migration do
  up do
    run "ALTER TABLE orders
         ADD CONSTRAINT check_order_status
         CHECK((order_status = 'New') OR
               (order_status = 'In progress') OR
               (order_status = 'Completed'))"
  end

  down do
    alter_table :orders do
      drop_constraint :check_order_status
    end
  end
end
