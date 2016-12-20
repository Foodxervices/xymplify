require 'rails_helper'

describe FoodItem do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :brand }
    it { is_expected.to validate_presence_of :supplier_id }
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :unit_price_currency }
    it { is_expected.to validate_presence_of :unit_price_without_promotion_currency }
    it { is_expected.to monetize :unit_price }
    it { is_expected.to monetize :unit_price_without_promotion }
    it { is_expected.to validate_numericality_of(:low_quantity).is_greater_than_or_equal_to(0) }
    it { is_expected.to allow_value("", nil).for(:low_quantity) }
  end

  context 'associations' do 
    it { is_expected.to belong_to :supplier }
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to belong_to :category }

    it { is_expected.to have_many :attachments }
    it { is_expected.to have_many :food_items_kitchens }
    it { is_expected.to have_many :inventories }
    it { is_expected.to have_many :order_items }

    it { is_expected.to have_and_belong_to_many :kitchens }
  end
end