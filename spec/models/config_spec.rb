require 'rails_helper'

describe Config do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :slug }
    it { is_expected.to validate_presence_of :value }
  end
end