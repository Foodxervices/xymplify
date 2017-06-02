require 'rails_helper'

describe Alert do
  context 'validations' do
    it { is_expected.to enumerize(:type).in(:pending_order, :approved_order, :rejected_order, :accepted_order, :cancelled_order, :low_quantity, :incoming_delivery) }
  end

  context 'associations' do
    it { is_expected.to belong_to :alertable }
  end
end