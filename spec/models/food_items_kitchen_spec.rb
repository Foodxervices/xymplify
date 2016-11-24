require 'rails_helper'

describe FoodItemsKitchen do 
  context 'associations' do 
    it { is_expected.to belong_to :food_item }
    it { is_expected.to belong_to :kitchen }
  end
end