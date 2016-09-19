require 'rails_helper'

describe Permission do
  context 'associations' do 
    it { is_expected.to have_and_belong_to_many :roles }
  end
end
