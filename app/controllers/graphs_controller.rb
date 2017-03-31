class GraphsController < AdminController
  def index
    @currency_symbol = Money::Currency.new(current_restaurant.currency).symbol

    graph = CostGraph.new(current_restaurant, kitchen: current_kitchen)

    if params[:type] == 'supplier'
      @data = graph.by_supplier
    else
      @data = graph.by_category
    end
  end
end