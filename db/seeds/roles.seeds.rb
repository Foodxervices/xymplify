puts '==== Destroy Role ===='
Role.destroy_all
ActiveRecord::Base.connection.execute(
  'ALTER SEQUENCE roles_id_seq RESTART WITH 1'
)
puts '==== End ===='

puts '==== Create Role ===='
Role.create([
  { name: 'Owner', permissions: ['restaurant__manage', 'supplier__manage', 'user_role__read', 'user_role__update', 'order__read', 'order__history', 'order__mark_as_approved', 'order__mark_as_rejected', 'order__mark_as_accepted', 'order__mark_as_declined', 'order__mark_as_delivered', 'order__mark_as_cancelled', 'order__update_placed', 'order__update_accepted', 'order__update_declined', 'order__update_delivered', 'order__update_cancelled', 'order__add_attachment', 'order__pay', 'kitchen__create', 'kitchen__update', 'kitchen__destroy', 'kitchen__dashboard', 'kitchen__import', 'kitchen__history', 'kitchen__reset_inventory', 'message__read', 'message__create', 'message__update', 'message__destroy', 'food_item__manage', 'inventory__read', 'inventory__update', 'requisition__read', 'requisition__create', 'dish__read', 'dish__create', 'dish__update', 'dish__destroy']},
  { name: 'Kitchen Manager', permissions: ['restaurant__read', 'restaurant__dashboard', 'supplier__read', 'user_role__read', 'order__read', 'order__history', 'order__mark_as_accepted', 'order__mark_as_declined', 'order__mark_as_delivered', 'order__mark_as_cancelled', 'order__update_placed', 'order__update_accepted', 'order__update_declined', 'order__update_delivered', 'order__update_cancelled', 'order__add_attachment', 'order__pay', 'kitchen__dashboard', 'kitchen__history', 'message__read', 'food_item__read', 'food_item__order', 'inventory__read', 'requisition__create'] }
])
puts '==== End ===='