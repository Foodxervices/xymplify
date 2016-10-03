class CategoriesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :food_item, :through => :restaurant, :parent => false

  def index
    @types = @food_items.select(:type).uniq.order(:type).map(&:type)
  end
end