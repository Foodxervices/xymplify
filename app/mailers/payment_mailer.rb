class PaymentMailer < ActionMailer::Base
  default template_path: 'mailers/payment'

  def notify_supplier_after_paid(order, paid)
    @order = order
    @supplier = @order.supplier
    @restaurant = @order.restaurant
    @user = @order.user
    @paid = paid

    mail(
      to: @supplier.email,
      cc: [@restaurant.email, @user.email],
      subject: "#{@restaurant.name} has just made a payment of #{humanized_money_with_symbol(paid)}"
    )
  end
end
