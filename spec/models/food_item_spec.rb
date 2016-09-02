require 'rails_helper'

describe FoodItem do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :unit }
    it { is_expected.to validate_presence_of :unit_price }
    it { is_expected.to enumerize(:unit).in(:pack, :kg, :litre, :can) }
  end

  context 'associations' do 
    it { is_expected.to belong_to :supplier }
  end
end