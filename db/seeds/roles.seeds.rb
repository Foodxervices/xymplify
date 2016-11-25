puts "==== Destroy Role ===="
Role.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE roles_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Role ===="
Role.create([
  { name: 'Owner', permissions: ['food_item__manage', 'inventory__read', 'inventory__update', 'restaurant__manage', 'supplier__manage', 'user_role__manage', 'kitchen__import', 'order__read', 'order__history', 'order__mark_as_delivered', 'order__mark_as_cancelled', 'order__update_placed', 'order__update_delivered', 'order__update_cancelled', 'message__read', 'message__create', 'message__update']},
  { name: 'Kitchen Manager', permissions: ['food_item__read', 'food_item__order', 'inventory__read', 'restaurant__dashboard', 'restaurant__read', 'supplier__read', 'user_role__read', 'order__read', 'order__history', 'order__mark_as_delivered', 'order__mark_as_cancelled', 'order__update_placed', 'message__read'] }
])
puts "==== End ===="