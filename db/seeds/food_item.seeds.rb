puts "==== Destroy Food Item ===="
FoodItem.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE food_items_id_seq RESTART WITH 1"
)
puts "==== End ===="