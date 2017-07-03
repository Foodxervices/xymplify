require 'rails_helper'

describe Inventory do
  context 'validations' do
    it { is_expected.to validate_presence_of :food_item_id }
    it { is_expected.to validate_presence_of :kitchen_id }
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_presence_of :current_quantity }
    it { is_expected.to validate_presence_of :quantity_ordered }
  end

  context 'associations' do
    it { is_expected.to belong_to :food_item }
    it { is_expected.to belong_to :kitchen }
    it { is_expected.to belong_to :restaurant }
  end
end