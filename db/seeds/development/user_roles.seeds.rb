after [:roles, :'development:users', :'development:restaurants'] do
  puts "==== Create User Role ===="
  saveur  = Restaurant.find_by_name('Saveur Pte Ltd')
  windsor = Restaurant.find_by_name('Windsor Pte Ltd')
  UserRole.create([
    { role: Role.find_by_name('Owner'), user: User.find_by_name('Windsor Owner'), restaurant: windsor},
    { role: Role.find_by_name('Kitchen Manager'), user: User.find_by_name('Windsor Manager'), restaurant: windsor, kitchens: [windsor.kitchens.last]},
    { role: Role.find_by_name('Owner'), user: User.find_by_name('Saveur Owner'), restaurant: saveur},
    { role: Role.find_by_name('Kitchen Manager'), user: User.find_by_name('Saveur Manager'), restaurant: saveur, kitchens: [saveur.kitchens.first]},
  ])
  puts "==== End ===="
end