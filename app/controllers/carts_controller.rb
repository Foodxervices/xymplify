class CartsController < ApplicationController
  load_and_authorize_resource :kitchen

  def show; end 
  
  def new
    @food_items = @kitchen.food_items
                             .select('food_items.*, c.name as category_name, s.name as supplier_name, s.priority')
                             .joins('LEFT JOIN suppliers s ON s.id = food_items.supplier_id')
                             .joins('LEFT JOIN categories c ON c.id = food_items.category_id')
                             .where(id: params[:ids])
                             .order('priority, code')
                             .accessible_by(current_ability)
  end

  def add
    @food_item = @kitchen.food_items.find(params[:food_item_id])

    authorize! :order, @food_item

    options = { user_id: current_user.id, kitchen_id: @kitchen.id, supplier_id: @food_item.supplier_id, status: :wip }
    
    @order = Order.where(options).first
    
    ActiveRecord::Base.transaction do
      if @order.nil?
        @order = Order.create(options.merge(outlet_name: @kitchen.name, outlet_address: @kitchen.address, outlet_phone: @kitchen.phone, request_for_delivery_at: 1.days.from_now.beginning_of_day + 10.hours))
        @order.gsts.create(name: 'GST', percent: 7)
      end

      @item = @order.items.find_or_create_by(food_item_id: @food_item.id)
      @item.unit_price = @food_item.unit_price
      @item.unit_price_without_promotion = @food_item.unit_price_without_promotion
      
      @item.quantity += params[:quantity].to_f
      
      @success = @item.save
      
      if !@success
        @message = @item.errors.full_messages.join("<br />")
      end
    end
    
    @order.destroy if @order.reload.price_with_gst == 0
  end

  def confirm
    @order = current_orders.find(params[:id])
  end

  def do_confirm
    @order = current_orders.find(params[:id])

    ActiveRecord::Base.transaction do
      @success = @order.update_attributes(purchase_params)
    end
  end

  def purchase
    suppliers = {}
    notices = []
    current_confirmed_orders.includes(:supplier).each do |order|
      supplier = order.supplier
      suppliers[supplier.id] ||= {}
      suppliers[supplier.id][:min_order_price] ||= supplier.min_order_price
      suppliers[supplier.id][:max_order_price] ||= supplier.max_order_price
      suppliers[supplier.id][:currency] ||= supplier.currency
      suppliers[supplier.id][:orders] ||= []
      suppliers[supplier.id][:name] ||= supplier.name
      suppliers[supplier.id][:orders_amount] ||= 0
      suppliers[supplier.id][:orders_amount] += order.price_with_gst.exchange_to(supplier.currency).to_f
      
      suppliers[supplier.id][:orders] << order
    end

    suppliers.each do |supplier_id, supplier|
      if supplier[:min_order_price] > supplier[:orders_amount]
        notices << "Please ensure that the total value of purchase from #{supplier[:name]} is more than #{Currency.format(supplier[:min_order_price], supplier[:currency])}."
      elsif supplier[:max_order_price].present? && supplier[:max_order_price] < supplier[:orders_amount]
        notices << "Please ensure that the total value of purchase from #{supplier[:name]} is less than #{Currency.format(supplier[:max_order_price], supplier[:currency])}."
      else
        supplier[:orders].each do |order|
          order.status = :placed 
          order.save
          OrderMailerWorker.perform_async(order.id, 'notify_supplier_after_placed')
          notices << "#{order.name} has been placed successfully."
        end
      end
    end
      
    redirect_to :back, notice: notices.join('<br /><br/>')
  end

  private 

  def purchase_params
    data = params.require(:order).permit(
        :outlet_name,
        :outlet_address,
        :outlet_phone,
        :request_for_delivery_at,
        :delivered_to_kitchen
      )
    data[:status] = :confirmed
    data
  end
end