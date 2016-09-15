puts "==== Destroy Restaurant ===="
Restaurant.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE restaurants_id_seq RESTART WITH 1"
)
puts "==== End ===="
