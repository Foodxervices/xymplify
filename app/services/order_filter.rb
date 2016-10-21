class OrderFilter
  include ActiveModel::Model
  attr_accessor :keyword
  attr_accessor :month

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

    if month.present?
      date = "#{month}-01".to_date

      @orders = @orders.where(status_updated_at: [date.beginning_of_month..date.end_of_month])
    end

    @orders
  end

  def persisted?
    false
  end
end