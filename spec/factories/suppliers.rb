FactoryGirl.define do
  factory :supplier do
    sequence(:name)     { |n| "Supplier #{n}" }
    restaurant
  end
end
