FactoryGirl.define do
  factory :food_item do
    sequence(:code)     { |n| "CODE#{n}" }
    sequence(:name)     { |n| "Food Item #{n}" }
    unit                'pack'
    unit_price          20
    supplier
    kitchen
    category
    tag_list              'Banana'
    sequence(:brand)    { |n| "Brand #{n}" }
    association :user ,   factory: :admin
  end
end
