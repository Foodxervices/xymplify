after [:roles, :users, :restaurants] do 
  puts "==== Destroy User Role ===="
  UserRole.destroy_all
  ActiveRecord::Base.connection.execute(
    "ALTER SEQUENCE user_roles_id_seq RESTART WITH 1"
  )
  puts "==== End ===="

  puts "==== Create User Role ===="
  windsor = Restaurant.find_by_name('Windsor')
  aihue   = Restaurant.find_by_name('Ai Hue')
  UserRole.create([
    { role: Role.find_by_name('Owner'), user: User.find_by_name('Windsor Owner'), restaurant: windsor},
    { role: Role.find_by_name('Owner'), user: User.find_by_name('Windsor Manager'), restaurant: windsor, kitchens: [windsor.kitchens.first]},
    { role: Role.find_by_name('Kitchen Manager'), user: User.find_by_name('Windsor Manager'), restaurant: windsor, kitchens: [windsor.kitchens.last]},
    { role: Role.find_by_name('Owner'), user: User.find_by_name('Ai Hue Owner'), restaurant: aihue},
    { role: Role.find_by_name('Kitchen Manager'), user: User.find_by_name('Ai Hue Manager'), restaurant: aihue, kitchens: [aihue.kitchens.first]},
  ])
  puts "==== End ===="
end