puts "==== Destroy Kitchen ===="
Kitchen.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE kitchens_id_seq RESTART WITH 1"
)
puts "==== End ===="