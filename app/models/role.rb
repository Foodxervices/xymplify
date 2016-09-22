class Role < ActiveRecord::Base
  extend Enumerize

  validates :name, presence: true

  serialize :permissions, Array
  enumerize :permissions, in: [
    'food_item__manage', 'food_item__read', 'food_item__create', 'food_item__update', 'food_item__destroy', 'food_item__update_current_quantity',
    'restaurant__manage', 'restaurant__read', 'restaurant__create', 'restaurant__update', 'restaurant__destroy',
    'supplier__manage', 'supplier__read', 'supplier__create', 'supplier__update', 'supplier__destroy',
    'user_role__manage', 'user_role__read', 'user_role__create', 'user_role__update', 'user_role__destroy', 
    'kitchen__import'
  ], multiple: true
end