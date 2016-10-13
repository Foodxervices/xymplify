class OrdersController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :order, :through => :restaurant, :shallow => true

  def index
    @orders = @orders.includes(:supplier).where(status: status).order(id: :desc)
  end

  def show
    respond_to do |format|
      format.js
      format.pdf do 
        @supplier = @order.supplier
        
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
      @order.destroy if @order.items.empty?
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
      ]
    )
  end

  def status
    params[:status] == 'archived' ? [:shipped, :cancelled] : :placed
  end
end