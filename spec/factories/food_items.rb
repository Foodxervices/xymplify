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

    before(:create) do |food_item|
      food_item.kitchen_ids = [create(:kitchen, restaurant: food_item.restaurant).id] if food_item.kitchen_ids.empty?
    end
  end
end
