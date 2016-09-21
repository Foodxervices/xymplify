puts "==== Destroy Role ===="
Role.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE roles_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Role ===="
Role.create([
  { name: 'Owner', permissions: ['food_item__manage', 'restaurant__manage', 'supplier__manage', 'user_role__manage']},
  { name: 'Kitchen Manager', permissions: ['food_item__read', 'restaurant__read', 'supplier__read', 'user_role__read'] }
])
puts "==== End ===="