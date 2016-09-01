puts "==== Create User ===="

User.create([
  { email: 'jamesla0604@gmail.com', password: '123123123', confirmed_at: Date.today }
])

puts "==== End ===="