class OrdersController < ApplicationController
  include ApplicationHelper

  AUTHORIZE_TOKEN_ACTIONS = [:show, :mark_as_accepted, :mark_as_declined]
  
  load_resource :restaurant
  load_resource :order, :through => :restaurant, :shallow => true

  authorize_resource :restaurant, except: AUTHORIZE_TOKEN_ACTIONS
  authorize_resource :order, :through => :restaurant, :shallow => true, except: AUTHORIZE_TOKEN_ACTIONS

  before_action :authorize_token, only: AUTHORIZE_TOKEN_ACTIONS

  def index
    @order_filter = OrderFilter.new(@orders, order_filter_params)

    @orders = @order_filter.result
                           .select('orders.*, suppliers.name as supplier_name')
                           .includes(:supplier, :gsts)
                           .where(status: status)
                           .order('supplier_name asc, status_updated_at desc')
                           .paginate(:page => params[:page])
    @grouped_orders = @orders.group_by{|order| order.supplier_name}
  end

  def show
    respond_to do |format|
      format.js
      format.pdf do 
        @supplier     = @order.supplier
        @kitchen      = @order.kitchen
        @restaurant   = @kitchen.restaurant
        @items        = @order.items.includes(:food_item)

        render pdf: @order.name, layout: 'main'
      end
    end
  end 
  
  def edit; end

  def update
    authorize! "update_#{@order.status}".to_sym, @order
    @success = @order.update_attributes(order_params)
    
    if @success
      order_name = @order.name
      @restaurant = @order.restaurant

      @message = []
      @message << "#{order_name} has been updated."

      if ['placed', 'accepted'].include?(@order.status)
        Premailer::Rails::Hook.perform(OrderMailer.notify_supplier_after_updated(@order)).deliver_later
        @message << "An email notification has been sent to the supplier." 
      end
      
      if @order.items.empty? && @order.destroy 
        return redirect_to :back, notice: "#{order_name} has been deleted." 
      end
    end

    if @order.status.wip?
      render :update_wip
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

  def mark_as_cancelled
    ActiveRecord::Base.transaction do
      @order.status = :cancelled
      @success = @order.save 
    end

    if @success
      Premailer::Rails::Hook.perform(OrderMailer.notify_supplier_after_cancelled(@order)).deliver_later
    end
    
    redirect_to :back
  end

  def mark_as_accepted
    if @order.status.placed?
      ActiveRecord::Base.transaction do
        @order.status = :accepted
        @success = @order.save  
      end

      if @success
        flash[:notice] = "#{@order.name} has been accepted." 
        @order.alerts.create(title: flash[:notice])
        Premailer::Rails::Hook.perform(OrderMailer.notify_restaurant_after_accepted(@order)).deliver_later
      end
    else
      invalid_status_notice
    end

    redirect_to root_url
  end

  def mark_as_declined
    if @order.status.placed?
      ActiveRecord::Base.transaction do
        @order.status = :declined
        @success = @order.save
      end

      if @success
        flash[:notice] = "#{@order.name} has been declined." 
        @order.alerts.create(title: flash[:notice])
        Premailer::Rails::Hook.perform(OrderMailer.notify_restaurant_after_declined(@order)).deliver_later
      end
    else
      invalid_status_notice
    end

    redirect_to root_url
  end

  def mark_as_delivered
    @order.status = :delivered

    ActiveRecord::Base.transaction do
      @success = @order.save
    end

    if @success
      flash[:notice] = "#{@order.name} has been delivered." 
      Premailer::Rails::Hook.perform(OrderMailer.notify_supplier_after_delivered(@order)).deliver_later
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
    params[:status] == 'archived' ? [:delivered, :cancelled, :declined] : [:placed, :accepted]
  end

  def authorize_token
    if !params[:token]
      authorize! action_name, @order 
    else
      redirect_to root_url, notice: 'Invalid Token' if params[:token] != @order.token
    end
  end

  def invalid_status_notice
    flash[:notice] = "#{@order.name} was #{@order.status} at #{format_datetime(@order.status_updated_at)}." 
  end
end