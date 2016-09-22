FactoryGirl.define do
  factory :role do
    sequence(:name)     { |n| "Role #{n}" } 
    permissions         ['food_item__manage', 'restaurant__manage']
  end
end
