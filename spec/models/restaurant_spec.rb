require 'rails_helper'

describe Restaurant do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :currency }
    it { is_expected.to allow_value("test@example.com").for(:email) }
    it { is_expected.to_not allow_value("invalid@email").for(:email) }
    it { is_expected.to enumerize(:receive_email).in(:after_updated, :after_placed, :after_accepted, :after_declined, :after_cancelled, :after_delivered, :after_paid) }
  end

  context 'associations' do 
    it { is_expected.to have_many :suppliers }
    it { is_expected.to have_many :kitchens }
    it { is_expected.to have_many :orders }
    it { is_expected.to have_many :order_items }
    it { is_expected.to have_many :food_items }
    it { is_expected.to have_many :user_roles }
    it { is_expected.to have_many :users }
    it { is_expected.to have_many :messages }
    it { is_expected.to have_many :dishes }
    it { is_expected.to have_many :dish_requisitions }
    it { is_expected.to have_many :requisitions }
  end
end