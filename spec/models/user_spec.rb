require 'rails_helper'

describe User do 
  context 'validations' do 
    it { is_expected.to enumerize(:type).in(:Admin) }
  end

  context 'associations' do 
    it { is_expected.to have_many :food_items }
  end
end
