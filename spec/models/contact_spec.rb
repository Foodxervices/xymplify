require 'rails_helper'

describe Contact do 
  context 'validations' do 
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :designation }
    it { is_expected.to validate_presence_of :organisation }
    it { is_expected.to validate_presence_of :your_query }
  end
end