require 'rails_helper'

describe OrderGst do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :percent }
    it { is_expected.to validate_numericality_of(:percent).is_greater_than(0).is_less_than(100) }
  end

  context 'associations' do 
    it { is_expected.to belong_to :order }
    it { is_expected.to belong_to :restaurant }
  end
end