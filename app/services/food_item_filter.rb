class FoodItemFilter
  include ActiveModel::Model
  attr_accessor :keyword
  attr_accessor :chicken_id

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    food_items = FoodItem.all
    food_items = food_items.joins("LEFT JOIN suppliers ON food_items.supplier_id = suppliers.id")
                           .where("
                                    food_items.code  ILIKE :keyword OR 
                                    food_items.name  ILIKE :keyword OR 
                                    food_items.brand ILIKE :keyword OR 
                                    suppliers.name   ILIKE :keyword 
                                  ", keyword: "%#{keyword}%") if keyword.present?
    food_items = food_items.where(chicken_id: chicken_id) if chicken_id.present?
    food_items
  end

  def persisted?
    false
  end
end