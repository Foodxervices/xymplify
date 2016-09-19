FactoryGirl.define do
  factory :role do
    name        'Owner'
    restaurant
    association :user ,   factory: :admin
  end
end
