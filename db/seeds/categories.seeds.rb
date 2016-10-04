puts "==== Destroy Food Item ===="
Category.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE categories_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Category ===="
Category.create([
  { name: 'Meat' },
  { name: 'Vegetables' },
  { name: 'Drinks' },
  { name: 'Others' }
])
puts "==== End ===="