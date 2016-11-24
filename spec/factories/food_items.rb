FactoryGirl.define do
  factory :food_item do
    sequence(:code)     { |n| "CODE#{n}" }
    sequence(:name)     { |n| "Food Item #{n}" }
    unit                'pack'
    unit_price_without_promotion 25
    unit_price          20
    supplier
    category
    tag_list              'Banana'
    restaurant
    sequence(:brand)    { |n| "Brand #{n}" }
    association :user ,   factory: :admin
  end
end
