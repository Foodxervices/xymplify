FactoryGirl.define do
  factory :chicken do
    sequence(:name)     { |n| "Chicken #{n}" }
    restaurant
  end
end
