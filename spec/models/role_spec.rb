require 'rails_helper'

describe Role do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :restaurant_id }
  end

  context 'associations' do 
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to have_and_belong_to_many :permissions }
  end
end