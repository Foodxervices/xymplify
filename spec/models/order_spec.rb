require 'rails_helper'

describe Order do
  context 'validations' do
    it { is_expected.to validate_presence_of :supplier_id }
    it { is_expected.to validate_presence_of :kitchen_id }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :outlet_name }
    it { is_expected.to validate_presence_of :outlet_address }
    it { is_expected.to validate_presence_of :outlet_phone }
    it { is_expected.to validate_numericality_of(:paid_amount).is_greater_than_or_equal_to(0) }
    it { is_expected.to enumerize(:status).in(:wip, :confirmed, :placed, :accepted, :declined, :delivered, :completed, :cancelled) }
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
        expect(order.reload.price.to_i).to eq 40
      end
    end

    context 'status: placed' do
      let!(:order) { create(:order, status: :placed) }

      it 'returns price' do
        expect(order.reload.price.to_i).to eq 40
      end
    end
  end

  describe '#status_updated_at' do
    let!(:order) { create(:order, status: :wip) }

    context 'status: wip' do
      it 'returns updated at' do
        expect(order.status_updated_at.to_date).to eq order.updated_at.to_date
      end
    end

    context 'status: placed' do
      before do
        order.status = :placed
        order.save
      end

      it 'returns placed at' do
        expect(order.status_updated_at).to eq order.placed_at
      end
    end

    context 'status: delivered' do
      before do
        order.status = :placed
        order.status = :delivered
        order.save
      end

      it 'returns delivered at' do
        expect(order.status_updated_at).to eq order.delivered_at
      end
    end
  end
end