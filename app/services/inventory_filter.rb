class InventoryFilter
  include ActiveModel::Model
  attr_accessor :keyword
  attr_accessor :tag_list
  attr_accessor :kitchen_id

  def initialize(inventories, attributes = {})
    @inventories = inventories
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    @inventories = @inventories.uniq
                               .joins("INNER JOIN food_items f ON inventories.food_item_id = f.id")
                               .joins("LEFT JOIN kitchens   k ON inventories.kitchen_id = k.id")
                               .joins("LEFT JOIN suppliers  s ON f.supplier_id = s.id")
                               .joins("LEFT JOIN categories c ON f.category_id = c.id")
                               .where("f.deleted_at IS NULL")

    if keyword.present?
      @inventories = @inventories.where("
                                        f.code             ILIKE :keyword OR
                                        f.name             ILIKE :keyword OR
                                        f.brand            ILIKE :keyword OR
                                        s.name             ILIKE :keyword OR
                                        k.name             ILIKE :keyword
                                      ", keyword: "%#{keyword}%")
    end

    if tag_list.present?
      @inventories = @inventories.where("f.cached_tag_list  ILIKE ?", "%#{tag_list}%")
    end

    if kitchen_id.present?
      @inventories = @inventories.where('k.id = ?', kitchen_id)
    end

    @inventories
  end

  def persisted?
    false
  end
end