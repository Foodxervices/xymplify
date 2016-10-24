class OrdersController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :order, :through => :restaurant, :shallow => true

  def index
    @order_filter = OrderFilter.new(@orders, order_filter_params)

    @orders = @order_filter.result
                           .includes(:supplier, :gsts)
                           .where(status: status)
                           .order(id: :desc)
  end

  def show
    respond_to do |format|
      format.js
      format.pdf do 
        @supplier     = @order.supplier
        @kitchen      = @order.kitchen
        @restaurant   = @kitchen.restaurant
        @items        = @order.items.includes(:food_item)

        render pdf: @order.name,
               layout: 'main'
      end
    end
  end 
  
  def edit; end

  def update
    authorize! "update_#{@order.status}".to_sym, @order
    @success = @order.update_attributes(order_params)
    
    if @success
      @order_id = @order.id
      @restaurant = @order.restaurant
      @order.destroy if @order.items.empty?
      @order = Order.find_by_id(@order.id)
    end
  end

  def destroy
    if @order.destroy
      flash[:notice] = "#{@order.name} has been deleted."
    else
      flash[:notice] = @order.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  def mark_as_shipped
    ActiveRecord::Base.transaction do
      @order.status = :shipped
      @order.save
    end

    redirect_to :back
  end

  def mark_as_cancelled
    ActiveRecord::Base.transaction do
      @order.status = :cancelled
      @order.save
    end

    redirect_to :back
  end

  private

  def order_params
    params.require(:order).permit(
      items_attributes: [
        :id,
        :unit_price,
        :quantity,
        :_destroy
      ],
      gsts_attributes: [
        :id,
        :name,
        :percent,
        :_destroy
      ]
    )
  end

  def order_filter_params
    order_filter = ActionController::Parameters.new(params[:order_filter])
    order_filter.permit(
      :keyword,
      :month
    )
  end

  def status
    params[:status] == 'archived' ? [:shipped, :cancelled] : :placed
  end
end