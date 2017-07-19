require 'rails_helper'

describe DishRequisition do
  context 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :kitchen }
    it { is_expected.to have_many :items }
    it { is_expected.to have_one :restaurant }
  end
end