require 'rails_helper'

describe Role do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it do 
      is_expected.to enumerize(:permissions).in(
        'food_item__manage', 'food_item__read', 'food_item__create', 'food_item__update', 'food_item__destroy', 'food_item__order',
        'restaurant__manage', 'restaurant__read', 'restaurant__create', 'restaurant__update', 'restaurant__destroy', 'restaurant__dashboard', 'restaurant__history',
        'supplier__manage', 'supplier__read', 'supplier__create', 'supplier__update', 'supplier__destroy',
        'user_role__manage', 'user_role__read', 'user_role__create', 'user_role__update', 'user_role__destroy',
        'kitchen__dashboard', 'kitchen__import', 'kitchen__history',
        'message__read', 'message__create', 'message__update', 'message__destroy', 
        'order__read', 'order__history', 'order__mark_as_delivered', 'order__mark_as_cancelled', 'order__update_placed', 'order__update_accepted', 'order__update_declined', 'order__update_delivered', 'order__update_cancelled',
        'inventory__read', 'inventory__update'
      ) 
    end
  end
end
