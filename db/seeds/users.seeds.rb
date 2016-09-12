puts "==== Destroy User ===="
User.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE users_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create User ===="
Admin.create([
  { email: 'admin@example.com', password: '123123123', confirmed_at: Date.today }
])
puts "==== End ===="