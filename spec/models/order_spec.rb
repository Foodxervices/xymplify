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
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to have_many :items }
    it { is_expected.to have_many :alerts }
  end

  describe '#price' do 
    context 'status: wip' do
      let!(:order) { create(:order) }

      it 'returns price' do
        expect(order.price.to_i).to eq 40
      end
    end

    context 'status: placed' do
      let!(:order) { create(:order, status: :placed) }

      it 'returns price' do
        expect(order.price.to_i).to eq 40
      end
    end
  end

  describe '#changed_status_at' do 
    let!(:order) { create(:order, status: :wip) }

    context 'status: wip' do
      it 'returns updated at' do
        expect(order.changed_status_at).to eq order.updated_at
      end
    end

    context 'status: placed' do
      before do 
        order.status = :placed 
        order.save 
      end

      it 'returns placed at' do
        expect(order.changed_status_at).to eq order.placed_at
      end
    end

    context 'status: shipped' do
      before do 
        order.status = :placed 
        order.status = :shipped 
        order.save 
      end

      it 'returns placed at' do
        expect(order.changed_status_at).to eq order.delivery_at
      end
    end
  end
end