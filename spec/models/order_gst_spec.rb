require 'rails_helper'

describe OrderGst do
  context 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :percent }
  end

  context 'associations' do
    it { is_expected.to belong_to :order }
    it { is_expected.to belong_to :restaurant }
    it { is_expected.to belong_to :kitchen }
  end
end