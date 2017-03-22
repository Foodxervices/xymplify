class CostGraph
  attr_accessor :restaurant
  attr_accessor :kitchen

  def initialize(restaurant, kitchen: nil)
    @restaurant = restaurant
    @kitchen = kitchen
  end

  def items
    return @items if @items.present?
    @items = OrderItem.joins(:order)
                      .includes(:category, order: :supplier)
                      .where(orders: { status: [:delivered, :completed] })
                      .order('orders.delivered_at asc')

    @items = @items.where(restaurant_id: restaurant.id) if restaurant.present?
    @items = @items.where(kitchen_id: kitchen.id) if kitchen.present?
    @items
  end

  def by_category
    res = {}

    items.each do |item|
      order = item.order
      next if order.nil?
      month = order.delivered_at.beginning_of_month

      category = item.category
      next if category.nil?

      res[month] ||= {}
      res[month][category.name] ||= 0
      res[month][category.name] = item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end

  def by_supplier
    res = {}

    items.each do |item|
      order = item.order
      next if order.nil?
      month = order.delivered_at.beginning_of_month

      supplier = order.supplier
      next if supplier.nil?

      res[month] ||= {}
      res[month][supplier.name] ||= 0
      res[month][supplier.name] = item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end
end