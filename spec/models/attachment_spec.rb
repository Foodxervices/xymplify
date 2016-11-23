require 'rails_helper'

describe Attachment do 
  context 'associations' do 
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to belong_to :food_item }
  end
end