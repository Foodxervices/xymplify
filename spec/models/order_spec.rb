require 'rails_helper'

describe Order do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :supplier_id }
    it { is_expected.to validate_presence_of :kitchen_id }
    it { is_expected.to validate_presence_of :user_id }
  end

  context 'associations' do 
    it { is_expected.to belong_to :supplier }
    it { is_expected.to belong_to :kitchen }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :restaurant }
  end

  describe '#price' do 
    context 'status: wip' do
      let!(:order) { create(:order) }

      it 'returns price' do
        expect(order.price.to_i).to eq 80
      end
    end

    context 'status: placed' do
      let!(:order) { create(:order, status: :placed) }

      it 'returns price' do
        expect(order.price.to_i).to eq 40
      end
    end
  end

  describe '#code' do 
    let!(:order) { create(:order) }

    it 'returns code' do
      expect(order.code.size).to eq 6
    end
  end
end