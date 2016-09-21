puts "==== Destroy User ===="
User.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE users_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Admin ===="
Admin.create([
  { name: 'Admin', email: 'admin@example.com', password: '123123123', confirmed_at: Date.today },
  { name: 'Nicholas', email: 'nicholas@foodxervices.com', password: '123123123', confirmed_at: Date.today }
])
puts "==== End ===="

puts "==== Create User ===="
User.create([
  { name: 'Owner Tester', email: 'test_restaurant_owner@example.com', password: '123123123', confirmed_at: Date.today },
  { name: 'Kitchen Manager Tester', email: 'test_kitchen_manager@example.com', password: '123123123', confirmed_at: Date.today }
])
puts "==== End ===="