require 'rails_helper'

describe UserRole do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :role_id }
    it { is_expected.to validate_presence_of :restaurant_id }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:role_id) }
  end

  context 'associations' do 
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :role }
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to have_and_belong_to_many :kitchens }
  end
end