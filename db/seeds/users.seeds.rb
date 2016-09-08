puts "==== Destroy User ===="
User.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE users_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create User ===="

User.create([
  { email: 'jamesla0604@gmail.com', password: '123123123', confirmed_at: Date.today }
])

puts "==== End ===="