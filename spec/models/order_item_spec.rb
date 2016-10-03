require 'rails_helper'

describe OrderItem do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :order_id }
    it { is_expected.to validate_presence_of :food_item_id }
    it { is_expected.to validate_presence_of :quantity }
  end

  context 'associations' do 
    it { is_expected.to belong_to :order }
    it { is_expected.to belong_to :food_item }
  end
end