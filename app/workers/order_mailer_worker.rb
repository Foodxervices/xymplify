class OrderMailerWorker
  include Sidekiq::Worker

  def perform(order_id, method)
    order = Order.find(order_id)

    Premailer::Rails::Hook.perform(OrderMailer.send(method, order)).deliver_now
  end
end