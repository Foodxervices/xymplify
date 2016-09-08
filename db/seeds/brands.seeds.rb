puts "==== Destroy Brand ===="
Brand.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE brands_id_seq RESTART WITH 1"
)
puts "==== End ===="
