require 'rails_helper'

describe FoodItem do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :brand }
    it { is_expected.to validate_presence_of :supplier_id }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :kitchen_id }
    it { is_expected.to monetize :unit_price }
    it { is_expected.to validate_numericality_of(:current_quantity).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:quantity_ordered).only_integer.is_greater_than_or_equal_to(0) }
  end

  context 'associations' do 
    it { is_expected.to belong_to :supplier }
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :kitchen }
    it { is_expected.to have_one :restaurant }
  end
end