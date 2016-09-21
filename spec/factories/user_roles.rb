FactoryGirl.define do
  factory :user_role do
    restaurant
    role
    association :user, factory: :admin
  end
end
