require 'rails_helper'

describe Role do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it do 
      is_expected.to enumerize(:permissions).in(
        'food_item__manage', 'food_item__read', 'food_item__create', 'food_item__update', 'food_item__destroy', 'food_item__update_current_quantity', 'food_item__order',
        'restaurant__manage', 'restaurant__read', 'restaurant__create', 'restaurant__update', 'restaurant__destroy', 'restaurant__dashboard',
        'supplier__manage', 'supplier__read', 'supplier__create', 'supplier__update', 'supplier__destroy',
        'user_role__manage', 'user_role__read', 'user_role__create', 'user_role__update', 'user_role__destroy',
        'kitchen__import', 
        'order__read', 'order__mark_as_delivered', 'order__mark_as_cancelled', 'order__update_placed', 'order__update_delivered', 'order__update_cancelled'
      ) 
    end
  end
end
