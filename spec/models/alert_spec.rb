require 'rails_helper'

describe Alert do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :title }
  end

  context 'associations' do 
    it { is_expected.to belong_to :alertable }
  end
end