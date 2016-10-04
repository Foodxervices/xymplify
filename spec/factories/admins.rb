FactoryGirl.define do
  factory :admin, parent: :user, class: Admin do
    sequence(:name)         { |n| "Admin #{n}"}
    sequence(:email)        { |n| "admin#{n}@example.com"}
  end
end
