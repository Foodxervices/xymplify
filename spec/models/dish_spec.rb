require 'rails_helper'

describe Dish do
  context 'validations' do
    it { is_expected.to validate_presence_of :name }
  end

  context 'associations' do
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to belong_to :user }

    it { is_expected.to have_many :items }
  end
end