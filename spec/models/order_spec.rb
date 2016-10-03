require 'rails_helper'

describe Order do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :supplier_id }
    it { is_expected.to validate_presence_of :kitchen_id }
  end

  context 'associations' do 
    it { is_expected.to belong_to :supplier }
    it { is_expected.to belong_to :kitchen }
    it { is_expected.to have_many :items }
  end
end