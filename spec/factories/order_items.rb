FactoryGirl.define do
  factory :order_item do
    order 
    food_item
    quantity 2
    unit_price_without_promotion 15
    unit_price 10
  end
end
