class OrderMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def notify_supplier_after_placed(order)
    @order = order
    @supplier = @order.supplier
    @restaurant = @order.restaurant
    @kitchen = @order.kitchen
    @items = @order.items
    @user = @order.user
    @mailer = true

    mail(
      to: @supplier.email,
      subject: "[New Order] #{@order.name}, #{@restaurant&.name}",
      template_path: 'mailers/order'
    )
  end
end
