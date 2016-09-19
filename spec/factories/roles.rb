FactoryGirl.define do
  factory :role do
    sequence(:name)     { |n| "Role #{n}" }
    restaurant
    association :user ,   factory: :admin
  end
end
