FactoryGirl.define do
  factory :kitchen do
    sequence(:name)     { |n| "Kitchen #{n}" }
    restaurant
  end
end
