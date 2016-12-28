class OrdersController < ApplicationController
  include ApplicationHelper

  AUTHORIZE_TOKEN_ACTIONS = [:show, :mark_as_accepted, :mark_as_declined]
  
  load_resource :kitchen
  load_resource :order, :through => :kitchen, :shallow => true

  authorize_resource :kitchen, except: AUTHORIZE_TOKEN_ACTIONS
  authorize_resource :order, :through => :kitchen, :shallow => true, except: AUTHORIZE_TOKEN_ACTIONS

  before_action :authorize_token, only: AUTHORIZE_TOKEN_ACTIONS

  def index
    @order_filter = OrderFilter.new(@orders, order_filter_params)

    @orders = @order_filter.result
                           .select('orders.*, suppliers.name as supplier_name')
                           .includes(:gsts)
                           .where(status: statuses.collect(&:last))
                           .order('supplier_name asc, status_updated_at desc')
                           .paginate(:page => params[:page])
    @grouped_orders = @orders.group_by{|order| order.supplier_name}
  end

  def show
    @supplier     = @order.supplier

    respond_to do |format|
      format.js
      format.pdf do     
        @kitchen      = @order.kitchen
        @restaurant   = @kitchen.restaurant
        @items        = @order.items.includes(:food_item)

        render pdf: "#{@order.name} - #{@supplier.name}", layout: 'main'
      end
    end
  end 
  
  def edit; end

  def update
    authorize! "update_#{@order.status}".to_sym, @order
    @success = @order.update_attributes(order_params)
  
    if @success
      order_name = @order.full_name
      @restaurant = @order.restaurant

      @message = []
      @message << "#{order_name} has been updated."

      if ['placed', 'accepted'].include?(@order.status)
        OrderMailerWorker.perform_async(@order.id, 'notify_supplier_after_updated')
        @message << "An email notification has been sent to the supplier." 
      end
      
      if @order.items.empty? && @order.destroy 
        return redirect_to :back, notice: "#{order_name} has been deleted." 
      end
    end

    if @order.status.wip? || @order.status.confirmed?
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
      OrderMailerWorker.perform_async(@order.id, 'notify_supplier_after_cancelled')
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
        alert = @order.alerts.create(type: :accepted_order)
        flash[:notice] = alert.title
        OrderMailerWorker.perform_async(@order.id, 'notify_restaurant_after_accepted')
      end
    else
      invalid_status_notice
    end

    if params[:_method] == 'patch'
      redirect_to :back
    else
      redirect_to root_url
    end
  end

  def mark_as_declined
    if @order.status.placed?
      ActiveRecord::Base.transaction do
        @order.status = :declined
        @success = @order.save
      end

      if @success
        alert = @order.alerts.create(type: :declined_order)
        flash[:notice] = alert.title
        OrderMailerWorker.perform_async(@order.id, 'notify_restaurant_after_declined')
      end
    else
      invalid_status_notice
    end

    if params[:_method] == 'patch'
      redirect_to :back
    else
      redirect_to root_url
    end
  end

  def mark_as_delivered
    @order.status = :delivered

    ActiveRecord::Base.transaction do
      @success = @order.save
    end

    if @success
      FrequentlyOrderedWorker.perform_async(@order.id)
      flash[:notice] = "#{@order.name} has been delivered." 
      OrderMailerWorker.perform_async(@order.id, 'notify_supplier_after_delivered')
    end

    redirect_to :back
  end

  def history
    respond_to do |format|
      format.js do 
        @version = @order.versions.last.becomes(Version)
        render 'versions/show'
      end
    end
  end

  def new_attachment
    render 'orders/attachment/new'
  end

  def add_attachment
    if @order.update_attributes(attachment_params)
      redirect_to :back, notice: "Attachment has been uploaded."
    else
      render 'orders/attachment/new'
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :outlet_name,
      :outlet_address,
      :outlet_phone,
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

  def attachment_params
    params.require(:order).permit(:attachment)
  end

  def order_filter_params
    order_filter = ActionController::Parameters.new(params[:order_filter])
    order_filter.permit(
      :keyword,
      :date_range,
      :status
    )
  end

  def statuses
    return @statuses if @statuses.present?

    if params[:status] == 'archived' 
      @statuses = [["Delivered", "delivered"], ["Cancelled", "cancelled"], ["Declined", "declined"]]
    else
      @statuses = [["Placed", "placed"], ["Accepted", "accepted"]]
    end

    @statuses 
  end

  def authorize_token
    if !params[:token]
      authorize! action_name.to_sym, @order 
    else
      redirect_to root_url, notice: 'Invalid Token' if params[:token] != @order.token
    end
  end

  def invalid_status_notice
    flash[:notice] = "#{@order.name} was #{@order.status} at #{format_datetime(@order.status_updated_at)}." 
  end
end