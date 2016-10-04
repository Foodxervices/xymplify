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

  describe '#current_unit_price' do 
    context 'status: wip' do
      let!(:order_item) { create(:order_item) }

      it 'returns current unit price' do
        expect(order_item.current_unit_price.to_i).to eq 20
      end
    end

    context 'status: placed' do
      let!(:order)      { create(:order, status: :placed) }
      let!(:order_item) { create(:order_item, order: order) }

      it 'returns current unit price' do
        expect(order_item.current_unit_price.to_i).to eq 10
      end
    end
  end

  describe '#total_price' do 
    context 'status: wip' do
      let!(:order_item) { create(:order_item) }

      it 'returns total price' do
        expect(order_item.total_price.to_i).to eq 40
      end
    end

    context 'status: placed' do
      let!(:order)      { create(:order, status: :placed) }
      let!(:order_item) { create(:order_item, order: order) }

      it 'returns total price' do
        expect(order_item.total_price.to_i).to eq 20
      end
    end
  end
end