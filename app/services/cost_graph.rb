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

  def by_food_item
    res = {}

    items.each do |item|
      order = item.order
      next if order.nil?
      week = order.delivered_at.beginning_of_week

      food_item = item.food_item
      next if food_item.nil?

      res[week] ||= {}
      res[week][food_item.name] ||= 0
      res[week][food_item.name] = item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end

  def by_category
    res = {}

    items.each do |item|
      order = item.order
      next if order.nil?
      week = order.delivered_at.beginning_of_week

      category = item.category
      next if category.nil?

      res[week] ||= {}
      res[week][category.name] ||= 0
      res[week][category.name] = item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end

  def by_supplier
    res = {}

    items.each do |item|
      order = item.order
      next if order.nil?
      week = order.delivered_at.beginning_of_week

      supplier = order.supplier
      next if supplier.nil?

      res[week] ||= {}
      res[week][supplier.name] ||= 0
      res[week][supplier.name] = item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end
end