require 'rails_helper'

describe Conversion do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :unit }
    it { is_expected.to validate_presence_of :rate }
  end

  context 'associations' do 
    it { is_expected.to belong_to :food_item }
  end
end