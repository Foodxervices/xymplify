class CloneFoodItemService
  include ActiveModel::Model
  attr_accessor :food_items
  attr_accessor :supplier_id
  attr_accessor :user_id
  attr_accessor :kitchen_ids

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def call
    origin_supplier = Supplier.find(supplier_id)

    kitchens = Kitchen.where(id: kitchen_ids).includes(:restaurant).group_by(&:restaurant).map do |restaurant, kitchens|
      supplier = restaurant.suppliers.find_by_email(origin_supplier.email)

      if supplier.nil?
        supplier = origin_supplier.dup
        supplier.restaurant_id = restaurant.id
        supplier.logo = origin_supplier.logo.url if origin_supplier.logo.exists?
        supplier.cc_emails = ''
        supplier.save
      end

      food_items.each do |item|
        i = FoodItem.find_or_initialize_by(code: item.code, restaurant_id: restaurant.id)
        i.name = item.name
        i.unit = item.unit
        i.brand = item.brand

        if i.new_record? || i.unit_price_cents == i.unit_price_without_promotion_cents
          i.unit_price = item.unit_price_without_promotion
        end

        i.unit_price_without_promotion = item.unit_price_without_promotion
        i.image = item.image.url if item.image.exists?
        i.category_id = item.category_id
        i.cached_tag_list = item.cached_tag_list
        i.country_of_origin = item.country_of_origin
        i.supplier_id = supplier.id
        i.user_id = user_id
        i.kitchen_ids = kitchens.map(&:id)
        i.save
      end
    end
  end

  def persisted?
    false
  end
end