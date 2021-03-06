require 'rails_helper'

describe Message do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_presence_of :content }
  end

  context 'associations' do 
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to belong_to :kitchen }
  end
end