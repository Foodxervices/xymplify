require 'rails_helper'

describe Seen do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_presence_of :user_id }
  end

  context 'associations' do 
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to belong_to :user }
  end
end