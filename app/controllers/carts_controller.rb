class CartsController < ApplicationController
  load_and_authorize_resource :restaurant

  def new
    @food_items = @restaurant.food_items
                             .accessible_by(current_ability)
                             .where(type: params[:type])
  end
end