puts "==== Destroy User ===="
User.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE users_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Admin ===="
Admin.create([
  { name: 'Admin', email: 'foodhub.main@gmail.com', password: 'foodhub123', confirmed_at: Date.today },
  { name: 'Nicholas', email: 'nicholas@foodxervices.com', password: '123123123', confirmed_at: Date.today }
])
puts "==== End ===="