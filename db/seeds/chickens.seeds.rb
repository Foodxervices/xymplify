puts "==== Destroy Chicken ===="
Chicken.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE chickens_id_seq RESTART WITH 1"
)
puts "==== End ===="
