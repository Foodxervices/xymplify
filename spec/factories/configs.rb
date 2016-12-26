FactoryGirl.define do
  factory :config do
    sequence(:name)     { |n| "Config #{n}" } 
    sequence(:slug)     { |n| "config-#{n}" } 
    value               'On'
  end
end
