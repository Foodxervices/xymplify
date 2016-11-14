require 'rails_helper'

describe OrderItem do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :order_id }
    it { is_expected.to validate_presence_of :food_item_id }
    it { is_expected.to validate_presence_of :quantity }
    it { is_expected.to validate_presence_of :unit_price_currency }
    it { is_expected.to validate_presence_of :unit_price_without_promotion_currency }
    it { is_expected.to monetize :unit_price }
    it { is_expected.to monetize :unit_price_without_promotion }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
  end

  context 'associations' do 
    it { is_expected.to belong_to :order }
    it { is_expected.to belong_to :food_item }
    it { is_expected.to belong_to :category }
  end

  describe '#total_price' do 
    let!(:order_item) { create(:order_item) }

    it 'returns total price' do
      expect(order_item.total_price.to_i).to eq 20
    end
  end
end