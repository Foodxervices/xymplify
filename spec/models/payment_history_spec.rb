require 'rails_helper'

describe PaymentHistory do
  context 'associations' do
    it { is_expected.to belong_to :order }
  end
end