require 'open-uri'

class OrderMailer < ActionMailer::Base
  include ApplicationHelper
  add_template_helper ApplicationHelper

  default template_path: 'mailers/order',
          template_name: 'template'

  def notify_supplier_after_updated(order)
    init(order)
    @message = "This Purchase Order from #{@restaurant.name} has been 
                <strong>updated</strong> at <strong>#{format_datetime(@order.updated_at)}</strong>."
    mail(
      to: @supplier.email,
      subject: "[Updated Order] #{@order.name}, #{@restaurant&.name}"
    )
  end

  def notify_supplier_after_placed(order)
    init(order)
    @message = "You got a Purchase Order from <strong>#{@restaurant.name}</strong> for delivery at <strong>#{format_datetime(@order.placed_at)}</strong>."
    mail(
      to: @supplier.email,
      subject: "[New Order] #{@order.name}, #{@restaurant&.name}"
    )
  end

  def notify_supplier_after_delivered(order)
    init(order)
    @message = "This Purchase Order from #{@restaurant.name} has been marked as 
                <strong>delivered</strong> at <strong>#{format_datetime(@order.delivered_at)}</strong>."

    mail(
      to: @supplier.email,
      subject: "[Delivered Order] #{@order.name}, #{@restaurant&.name}"
    )
  end

  def notify_supplier_after_cancelled(order)
    init(order)
    @message = "This Purchase Order from #{@restaurant.name} has been marked as 
                <strong>cancelled</strong> at <strong>#{format_datetime(@order.cancelled_at)}</strong>."

    mail(
      to: @supplier.email,
      subject: "[Cancelled Order] #{@order.name}, #{@restaurant&.name}"
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
    attachments["#{@order.name}.pdf"] = open(order_url(order, format: :pdf, token: @order.token)).read if !Rails.env.development?
  end
end
