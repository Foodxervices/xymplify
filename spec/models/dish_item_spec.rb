require 'rails_helper'

describe DishItem do
  context 'validations' do
    it { is_expected.to validate_presence_of :quantity }
  end

  context 'associations' do
    it { is_expected.to belong_to :dish }
    it { is_expected.to belong_to :food_item }
  end
end