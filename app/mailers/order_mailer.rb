require 'open-uri'

class OrderMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def notify_supplier_after_placed(order)
    init(order)

    mail(
      to: @supplier.email,
      subject: "[New Order] #{@order.name}, #{@restaurant&.name}",
      template_path: 'mailers/order'
    )
  end

  def notify_supplier_after_delivered(order)
    init(order)

    mail(
      to: @supplier.email,
      subject: "[Delivered Order] #{@order.name}, #{@restaurant&.name}",
      template_path: 'mailers/order'
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
