class FoodItemFilter
  include ActiveModel::Model
  attr_accessor :keyword
  attr_accessor :kitchen_ids

  def initialize(food_items, attributes = {})
    @food_items = food_items
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    @food_items = @food_items.uniq.joins("LEFT JOIN suppliers s ON food_items.supplier_id = s.id")

    if keyword.present?
      @food_items = @food_items.where("
                                        food_items.code             ILIKE :keyword OR 
                                        food_items.name             ILIKE :keyword OR 
                                        food_items.brand            ILIKE :keyword OR 
                                        food_items.cached_tag_list  ILIKE :keyword OR 
                                        s.name   ILIKE :keyword
                                      ", keyword: "%#{keyword}%") 
    end

    if kitchen_ids.present?
      @food_items = @food_items.joins("LEFT JOIN food_items_kitchens fk ON food_items.id = fk.food_item_id")
                               .where(fk: { kitchen_id: kitchen_ids}) 
    end

    @food_items
  end

  def persisted?
    false
  end
end