require 'rails_helper'

describe User do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :type }
    it { is_expected.to enumerize(:type).in('User', 'Admin') }
  end

  context 'associations' do 
    it { is_expected.to have_many :food_items }
    it { is_expected.to have_many :roles }
  end
end
