class OrderFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(orders, attributes = {})
    @orders = orders
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    @orders = @orders.uniq
                     .joins("LEFT JOIN suppliers ON orders.supplier_id = suppliers.id")
                     .joins("LEFT JOIN order_items ON order_items.order_id = orders.id")

    if keyword.present?
      @orders = @orders.where("
                                orders.name                  ILIKE :keyword OR 
                                suppliers.name              ILIKE :keyword OR 
                                order_items.name            ILIKE :keyword 
                              ", keyword: "%#{keyword}%") 
    end

    @orders
  end

  def persisted?
    false
  end
end