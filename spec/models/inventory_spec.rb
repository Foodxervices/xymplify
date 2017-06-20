require 'rails_helper'

describe Inventory do
  context 'validations' do
    it { is_expected.to validate_presence_of :food_item_id }
    it { is_expected.to validate_presence_of :kitchen_id }
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_presence_of :current_quantity }
    it { is_expected.to validate_presence_of :quantity_ordered }
    it { is_expected.to validate_numericality_of(:current_quantity).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:quantity_ordered).is_greater_than_or_equal_to(0) }
  end

  context 'associations' do
    it { is_expected.to belong_to :food_item }
    it { is_expected.to belong_to :kitchen }
    it { is_expected.to belong_to :restaurant }
  end
end