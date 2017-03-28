puts "==== Create User ===="
User.create([
  { name: 'Windsor Owner',   email: 'windsor_owner@example.com',   password: '123123123', confirmed_at: Date.today },
  { name: 'Windsor Manager', email: 'windsor_manager@example.com', password: '123123123', confirmed_at: Date.today },
  { name: 'Saveur Owner',    email: 'saveur_owner@example.com',    password: '123123123', confirmed_at: Date.today },
  { name: 'Saveur Manager',  email: 'saveur_manager@example.com',  password: '123123123', confirmed_at: Date.today },
])
puts "==== End ===="