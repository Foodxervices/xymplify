class OrdersController < PublicController
  before_action :authenticate_user!, except: [:show]
  load_resource :restaurant
  load_resource :order, :through => :restaurant, :shallow => true
  authorize_resource :restaurant, except: [:show]
  authorize_resource :order, :through => :restaurant, :shallow => true, except: [:show]

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
      format.js do 
        authorize! :show, @order
      end
      format.pdf do 
        if !params[:token]
          authorize! :show, @order 
        else
          redirect_to root_url, notice: 'Invalid Token' if params[:token] != @order.token
        end
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
      order_name = @order.name
      @restaurant = @order.restaurant
      @order.destroy if @order.items.empty?
      @order = Order.find_by_id(@order.id)

      return redirect_to :back, notice: "#{order_name} has been deleted." if @order.nil?
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
  
  def mark_as_delivered
    ActiveRecord::Base.transaction do
      @order.status = :delivered
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
    params[:status] == 'archived' ? [:delivered, :cancelled, :declined] : [:placed, :accepted]
  end
end