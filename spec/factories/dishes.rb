FactoryGirl.define do
  factory :dish do
    sequence(:name)     { |n| "Dish #{n}" }
  end
end
