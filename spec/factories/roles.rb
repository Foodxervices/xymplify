FactoryGirl.define do
  factory :role do
    sequence(:name)     { |n| "Role #{n}" } 
    permissions         ['kitchen__read', 'kitchen__edit']
  end
end
