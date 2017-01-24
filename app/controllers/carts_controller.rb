class CartsController < ApplicationController
  include ApplicationHelper
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
        @order = Order.create(options.merge(outlet_name: @kitchen.name, outlet_address: @kitchen.address, outlet_phone: @kitchen.phone))
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
      @success = @order.update_attributes(confirm_params)
    end

    if !@success
      @request_for_delivery_start_at_invalid = @order.request_for_delivery_start_at.blank?
      @request_for_delivery_end_at_invalid = @order.request_for_delivery_end_at.blank?
    end
  end

  def purchase
    suppliers = {}
    notices = []
    current_confirmed_orders.includes(:supplier).each do |order|
      supplier = order.supplier
      suppliers[supplier.id] ||= {
        info: supplier,
        errors: [],
        orders: [],
        orders_amount: 0
      }
      order.validate_request_date

      if order.errors.messages.any?
        suppliers[supplier.id][:errors] << order.long_name + ': ' + order.errors.full_messages.join('. ')
      else
        suppliers[supplier.id][:orders_amount] += order.price_with_gst.exchange_to(supplier.currency).to_f
        suppliers[supplier.id][:orders] << order
      end
    end

    suppliers.each do |supplier_id, supplier|
      s = supplier[:info]

      if supplier[:errors].any?
        supplier[:errors].each do |message|
          notices << message
        end
      elsif s.min_order_price > supplier[:orders_amount]
        notices << "Please ensure that the total value of purchase from #{s.name} is more than #{Currency.format(s.min_order_price, s.currency)}."
      elsif s.max_order_price.present? && s.max_order_price < supplier[:orders_amount]
        notices << "Please ensure that the total value of purchase from #{s.name} is less than #{Currency.format(s.max_order_price, s.currency)}."
      else
        supplier[:orders].each do |order|
          order.status = :placed
          order.save
          OrderMailerWorker.perform_async(order.id, 'notify_supplier_after_placed')
          notices << "#{order.long_name} has been placed successfully."
        end
      end
    end

    notices.delete_if(&:blank?)
    flash[:notice] = notices.join('<br /><br/>') if notices.any?
    redirect_to :back
  end

  def update_request_for_delivery_start_at
    update_request_for_delivery_time('start')
  end

  def update_request_for_delivery_end_at
    update_request_for_delivery_time('end')
  end

  private

  def update_request_for_delivery_time(type)
    order = current_orders.find(params[:id])
    order.send("request_for_delivery_#{type}_at=", Time.zone.parse(params[:time]))

    order.validate_request_date

    if order.errors.messages.any?
      render json: { success: false, message: order.errors.full_messages.join('. ') }
    else
      render json: { success: order.save }
    end
  end

  def confirm_params
    data = params.require(:order).permit(
        :outlet_name,
        :outlet_address,
        :outlet_phone,
        :delivered_to_kitchen
      )
    data[:status] = :confirmed
    data
  end
end