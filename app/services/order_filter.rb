class OrderFilter
  include ActiveModel::Model

  DATE_FORMAT = '%d/%m/%Y'

  attr_accessor :keyword
  attr_accessor :date_range
  attr_accessor :status
  attr_accessor :start_date
  attr_accessor :end_date

  def initialize(orders, attributes = {})
    @orders = orders
    attributes.each { |name, value| send("#{name}=", value) }
    @date_range = default_date_range if !date_range.present?
    from, to    = date_range.split(' - ')
    @start_date = Date.strptime(from, DATE_FORMAT)
    @end_date   = Date.strptime(to, DATE_FORMAT)
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

    @orders = @orders.where(status_updated_at: (start_date.beginning_of_day..end_date.end_of_day))
    
    if status.present?
      @orders = @orders.where(status: status)
    end

    @orders
  end

  def persisted?
    false
  end

  def default_date_range
    from = 30.days.ago.strftime(DATE_FORMAT)
    to = Time.zone.now.strftime(DATE_FORMAT)
    "#{from} - #{to}"
  end
end