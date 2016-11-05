FactoryGirl.define do
  factory :supplier do
    sequence(:name)     { |n| "Supplier #{n}" }
    sequence(:email)    { |n| "email#{n}@example.com" }
    restaurant
  end
end
