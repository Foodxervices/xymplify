require 'rails_helper'

describe Chicken do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
  end

  context 'associations' do 
    it { is_expected.to belong_to :restaurant }
  end
end