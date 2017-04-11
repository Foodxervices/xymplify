class OrderMailerWorker
  include Sidekiq::Worker

  def perform(order_id, method, remarks = '')
    order = Order.find(order_id)

    if remarks.present?
      Premailer::Rails::Hook.perform(OrderMailer.send(method, order, remarks)).deliver_now
    else
      Premailer::Rails::Hook.perform(OrderMailer.send(method, order)).deliver_now
    end
  end
end