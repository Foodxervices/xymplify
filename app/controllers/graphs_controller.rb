class GraphsController < AdminController
  def index
    @currency_symbol = Money::Currency.new(current_restaurant.currency).symbol

    graph = CostGraph.new(current_restaurant, kitchen: current_kitchen)

    case params[:type]
    when 'supplier'
      @data = graph.by_supplier
    when 'category'
      @data = graph.by_category
    when 'food_item'
      @data = graph.by_food_item
    end
  end
end