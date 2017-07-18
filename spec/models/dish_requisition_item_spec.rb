require 'rails_helper'

describe DishRequisitionItem do
  context 'validations' do
    it { is_expected.to validate_presence_of :quantity }
  end

  context 'associations' do
    it { is_expected.to belong_to :dish }
    it { is_expected.to belong_to :dish_requisition }
  end
end