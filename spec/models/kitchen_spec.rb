require 'rails_helper'

describe Kitchen do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :phone }
  end

  context 'associations' do 
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to have_many :orders }
    it { is_expected.to have_many :messages }
    it { is_expected.to have_and_belong_to_many :food_items }
    it { is_expected.to have_and_belong_to_many :user_roles }
  end
end