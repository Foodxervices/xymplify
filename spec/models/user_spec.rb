require 'rails_helper'

describe User do 
  context 'associations' do 
    it { is_expected.to have_many :food_items }
  end
end
