class PaymentMailerWorker
  include Sidekiq::Worker

  def perform(order_id, paid)
    order = Order.find(order_id)
    Premailer::Rails::Hook.perform(PaymentMailer.notify_supplier_after_paid(order, paid)).deliver_now
  end
end