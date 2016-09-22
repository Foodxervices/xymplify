after [:roles, :users, :restaurants] do 
  puts "==== Destroy User Role ===="
  UserRole.destroy_all
  ActiveRecord::Base.connection.execute(
    "ALTER SEQUENCE user_roles_id_seq RESTART WITH 1"
  )
  puts "==== End ===="

  puts "==== Create User Role ===="
  restaurant = Restaurant.first
  UserRole.create([
    { role: Role.find_by_name('Owner'), user: User.find_by_name('Owner Tester'), restaurant: restaurant},
    { role: Role.find_by_name('Kitchen Manager'), user: User.find_by_name('Kitchen Manager Tester'), restaurant: restaurant, kitchens: [restaurant.kitchens.first]}
  ])
  puts "==== End ===="
end