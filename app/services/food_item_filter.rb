class FoodItemFilter
  include ActiveModel::Model
  attr_accessor :keyword
  attr_accessor :kitchen_id

  def initialize(food_items, attributes = {})
    @food_items = food_items
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    @food_items = @food_items.joins("LEFT JOIN suppliers ON food_items.supplier_id = suppliers.id")
    @food_items = @food_items.where("
                                    food_items.code  ILIKE :keyword OR 
                                    food_items.name  ILIKE :keyword OR 
                                    food_items.brand ILIKE :keyword OR 
                                    suppliers.name   ILIKE :keyword OR
                                    kitchens.name    ILIKE :keyword 
                                  ", keyword: "%#{keyword}%") if keyword.present?
    @food_items = @food_items.where('food_items.kitchen_id = ?', kitchen_id) if kitchen_id.present?
    @food_items
  end

  def persisted?
    false
  end
end