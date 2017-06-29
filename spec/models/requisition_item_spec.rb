require 'rails_helper'

describe RequisitionItem do
  context 'validations' do
    it { is_expected.to validate_presence_of :quantity }
  end

  context 'associations' do
    it { is_expected.to belong_to :food_item }
    it { is_expected.to belong_to :requisition }
  end
end