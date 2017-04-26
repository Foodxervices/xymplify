class PaymentMailer < ActionMailer::Base
  default template_path: 'mailers/payment'

  def notify_supplier_after_paid(order, paid)
    @order = order
    @supplier = @order.supplier
    @restaurant = @order.restaurant
    @user = @order.user
    @paid = Money.from_amount(paid, @order.paid_amount_currency)

    @cc = @supplier.cc_emails.split(',')
    @cc << @restaurant.email if @restaurant.receive_email.after_paid?
    @cc << @user.email if @user.receive_email?

    subject = "#{@order.name}, #{@restaurant.name} - #{order.outlet_address}"

    if order.paid?
      subject = "Full Payment - #{subject}"
    else
      subject = "Partial Payment - #{subject}"
    end

    mail(
      to: @supplier.email,
      cc: @cc,
      subject: subject
    )
  end
end
