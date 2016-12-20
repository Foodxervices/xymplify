require 'rails_helper'

describe Supplier do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :min_order_price }
    it { is_expected.to validate_numericality_of(:min_order_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:max_order_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to allow_value("test@example.com").for(:email) }
    it { is_expected.to_not allow_value("invalid@email").for(:email) }
  end

  context 'associations' do 
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to have_many :food_items }
    it { is_expected.to have_many :orders }
  end
end
