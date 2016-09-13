FactoryGirl.define do
  factory :admin do
    sequence(:name)         { |n| "Admin #{n}"}
    sequence(:email)        { |n| "admin#{n}@example.com"}
    password                '123123123'
    confirmed_at Date.today
    type 'Admin'
  end
end
