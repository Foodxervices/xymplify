class FoodItemFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    food_items = FoodItem.all
    food_items = food_items.where("food_items.code ILIKE :keyword OR food_items.name ILIKE :keyword", keyword: "%#{keyword}%") if keyword.present?
    food_items
  end

  def persisted?
    false
  end
end