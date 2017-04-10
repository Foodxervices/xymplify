class CostGraph
  attr_accessor :restaurant
  attr_accessor :kitchen
  attr_accessor :mode
  attr_accessor :type

  def initialize(restaurant, kitchen: nil, mode: nil, type: nil)
    @restaurant = restaurant
    @kitchen = kitchen
    @mode = mode || 'month'
    @type = type || 'supplier'
  end

  def result
    send("by_#{type}")
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
      view_mode = order.delivered_at.send("beginning_of_#{mode}")

      food_item = item.food_item
      next if food_item.nil?

      res[view_mode] ||= {}
      res[view_mode][food_item.name] ||= 0
      res[view_mode][food_item.name] += item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end

  def by_category
    res = {}

    items.each do |item|
      order = item.order
      next if order.nil?
      view_mode = order.delivered_at.send("beginning_of_#{mode}")

      category = item.category
      next if category.nil?

      res[view_mode] ||= {}
      res[view_mode][category.name] ||= 0
      res[view_mode][category.name] += item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end

  def by_supplier
    res = {}

    items.each do |item|
      order = item.order
      next if order.nil?
      view_mode = order.delivered_at.send("beginning_of_#{mode}")

      supplier = order.supplier
      next if supplier.nil?

      res[view_mode] ||= {}
      res[view_mode][supplier.name] ||= 0
      res[view_mode][supplier.name] += item.total_price.exchange_to(restaurant.currency).to_f
    end

    res.to_json
  end
end