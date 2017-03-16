class GraphsController < ApplicationController
  def index
    @restaurant = Restaurant.accessible_by(current_ability).find(params[:restaurant_id])
    @kitchen = @restaurant.kitchens.accessible_by(current_ability).find(params[:kitchen_id]) if params[:kitchen_id]
    @currency_symbol = Money::Currency.new(@restaurant.currency).symbol

    graph = CostGraph.new(@restaurant, kitchen: @kitchen)

    if params[:type] == 'supplier'
      @data = graph.by_supplier
    else
      @data = graph.by_category
    end
  end
end