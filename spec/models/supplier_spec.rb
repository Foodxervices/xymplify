require 'rails_helper'

describe Supplier do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to allow_value("test@example.com").for(:email) }
    it { is_expected.to_not allow_value("invalid@email").for(:email) }
  end

  context 'associations' do 
    it { is_expected.to have_many :food_items }
  end
end
