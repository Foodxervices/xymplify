FactoryGirl.define do
  factory :order do
    supplier
    kitchen
    user
    outlet_name     "Kitchen 1"
    outlet_address "2 Orchard Turn, #04-11, ION Orchard, 238801"
    outlet_phone   "90608421"
    request_for_delivery_start_at 1.day.from_now
    request_for_delivery_end_at 2.day.from_now
    paid_amount 0

    after(:create) do |order|
      create_list(:order_item, 2, order_id: order.id)
      order.cache_price
    end
  end
end