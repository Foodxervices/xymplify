class GraphsController < AdminController
  def index
    @currency_symbol = Money::Currency.new(current_restaurant.currency).symbol

    graph = CostGraph.new(current_restaurant, kitchen: current_kitchen, type: params[:type], mode: params[:mode])

    @mode = graph.mode
    @type = graph.type
    @data = graph.result
  end
end