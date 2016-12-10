require 'rails_helper'

describe RestaurantCategory do 
  context 'associations' do 
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to belong_to :category }

    it { is_expected.to have_many :food_items }
  end
end