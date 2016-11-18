FactoryGirl.define do
  factory :kitchen do
    sequence(:name)     { |n| "Kitchen #{n}" }
    address "2 Orchard Turn, #04-11, ION Orchard, 238801"
    phone   "90608421"
    restaurant
  end
end
