puts "==== Destroy Supplier ===="
Supplier.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE suppliers_id_seq RESTART WITH 1"
)
puts "==== End ===="