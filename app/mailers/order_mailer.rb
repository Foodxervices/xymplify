class OrderMailer < ActionMailer::Base
  include ApplicationHelper
  include OrderHelper
  add_template_helper ApplicationHelper
  add_template_helper OrderHelper

  default template_path: 'mailers/order',
          template_name: 'template'

  def notify_supplier_after_updated(order, remarks)
    init(order)
    @receiver = @supplier
    @cc = []
    @cc << @restaurant.email if @restaurant.receive_email.after_updated?
    @cc << @user.email if @user.receive_email?
    @message = "This Purchase Order from #{@restaurant.name} has been
                <strong>updated</strong> at <strong>#{format_datetime(@order.updated_at)}</strong>."
    @remarks = remarks

    subject = "#{@order.name}, #{@restaurant.name} - #{order.outlet_address}"

    if order.status.delivered? || order.status.completed?
      subject = "Delivered and Updated Order - #{subject}"
    else
      subject = "Updated Order - #{subject}"
    end

    mail(
      to: @supplier.email,
      cc: @cc,
      subject: subject
    )
  end

  def notify_supplier_after_placed(order)
    order.update_column(:token, SecureRandom.urlsafe_base64)
    init(order)
    @cc = []
    @cc << @restaurant.email if @restaurant.receive_email.after_updated?
    @cc << @user.email if @user.receive_email?
    @receiver = @supplier
    @message = "You got a Purchase Order from <strong>#{@restaurant.name}</strong> for delivery at: <strong>#{date_of_delivery(@order)}</strong>."

    mail(
      to: @supplier.email,
      cc: @cc,
      subject: "New Order - #{@order.name}, #{@restaurant.name} - #{order.outlet_address}"
    )
  end

  def notify_restaurant_after_accepted(order)
    init(order)
    @to = []
    @to << @user.email if @user.receive_email?
    @to << @restaurant.email if @restaurant.receive_email.after_accepted?
    return if @to.empty?

    @receiver = @restaurant
    @message = "This Purchase Order for #{@supplier.name} has been marked as
                <strong>accepted</strong> at <strong>#{format_datetime(@order.accepted_at)}</strong>."
    mail(
      to: @to,
      cc: @supplier.email,
      subject: "Accepted Order - #{@order.name}, #{@supplier.name} - #{order.outlet_address}"
    )
  end

  def notify_restaurant_after_declined(order)
    init(order)
    @to = []
    @to << @user.email if @user.receive_email?
    @to << @restaurant.email if @restaurant.receive_email.after_declined?
    return if @to.empty?

    @receiver = @restaurant

    @message = "This Purchase Order for #{@supplier.name} has been marked as
                <strong>declined</strong> at <strong>#{format_datetime(@order.declined_at)}</strong>."
    mail(
      to: @to,
      cc: @supplier.email,
      subject: "Declined Order - #{@order.name}, #{@supplier.name} - #{order.outlet_address}"
    )
  end

  def notify_supplier_after_cancelled(order)
    init(order)
    @receiver = @supplier
    @cc = []
    @cc << @restaurant.email if @restaurant.receive_email.after_cancelled?
    @cc << @user.email if @user.receive_email?

    @message = "This Purchase Order from #{@restaurant.name} has been marked as
                <strong>cancelled</strong> at <strong>#{format_datetime(@order.cancelled_at)}</strong>."

    mail(
      to: @supplier.email,
      cc: @cc,
      subject: "Cancelled Order - #{@order.name}, #{@restaurant.name} - #{order.outlet_address}"
    )
  end

  def notify_supplier_after_delivered(order, remarks, order_changed)
    init(order)
    @receiver = @supplier
    @cc = []
    @cc << @restaurant.email if @restaurant.receive_email.after_delivered?
    @cc << @user.email if @user.receive_email?

    @message = "This Purchase Order from #{@restaurant.name} has been marked as
                <strong>delivered</strong> at <strong>#{format_datetime(@order.delivered_at)}</strong>."
    @remarks = remarks

    subject = "#{@order.name}, #{@restaurant.name} - #{order.outlet_address}"

    if order_changed
      subject = "Delivered and Updated Order - #{subject}"
    else
      subject = "Delivered Order - #{subject}"
    end

    mail(
      to: @supplier.email,
      cc: @cc,
      subject: subject
    )
  end

  private
  def init(order)
    @order = order
    @supplier = @order.supplier
    @restaurant = @order.restaurant
    @kitchen = @order.kitchen
    @items = @order.items
    @user = @order.user

    if !Rails.env.development? && !Rails.env.test?
      attachments["#{@order.name}.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(
          layout: 'main',
          template: 'orders/show.pdf.slim',
          locals: { current_restaurant: @restaurant }
          )
      )
    end
  end
end
