FactoryGirl.define do
  factory :order do
    supplier
    kitchen
    user 

    after(:create) do |order|
      create_list(:order_item, 2, order_id: order.id)
    end
  end
end