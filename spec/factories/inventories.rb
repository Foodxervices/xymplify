FactoryGirl.define do
  factory :inventory do
    restaurant
    food_item
    kitchen
    current_quantity 2
    quantity_ordered 2
  end
end
