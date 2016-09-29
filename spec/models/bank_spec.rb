require 'rails_helper'

describe Bank do 
  context 'associations' do 
    it { is_expected.to belong_to :bankable }
  end
end