class CartsController < AdminController
  include ApplicationHelper
  load_and_authorize_resource :kitchen, through: :current_restaurant

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
        @order = Order.create(options.merge(outlet_name: @kitchen.name, outlet_address: @kitchen.address, outlet_phone: @kitchen.phone, request_delivery_date: @food_item.supplier&.next_available_delivery_date, gsts_attributes: [{name: 'GST', percent: 7}]))
      end

      @item = @order.add(@food_item, params[:quantity])

      @success = @order.save

      if !@success
        @message = @order.errors.full_messages.join("<br />")
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
      @request_for_delivery_at_invalid = @order.request_delivery_date.blank?
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
          if can?(:mark_as_approved, order)
            order.status = :placed
            OrderMailer.notify_supplier_after_placed(order).deliver_later
            notices << "#{order.long_name} has been placed successfully."
          else
            order.status = :pending
            OrderMailer.asking_for_approval(order).deliver_later
            notices << "#{order.long_name} is pending for approval."
          end
          order.save
        end
      end
    end

    notices.delete_if(&:blank?)
    flash[:notice] = notices.join('<br /><br/>') if notices.any?
    redirect_to :back
  end

  def update_request_delivery_date
    order = current_orders.find(params[:id])
    order.request_delivery_date = Time.zone.parse(params[:date])
    order.start_time = params[:start_time]
    order.end_time = params[:end_time]

    if order.errors.messages.any?
      render json: { success: false, message: order.errors.full_messages.join('. ') }
    else
      render json: { success: order.save }
    end
  end

  private

  def confirm_params
    data = params.require(:order).permit(
        :outlet_name,
        :outlet_address,
        :outlet_phone,
        :delivered_to_kitchen,
        :eatery_remarks
      )
    data[:status] = :confirmed
    data
  end
end