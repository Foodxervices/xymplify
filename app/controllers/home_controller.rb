class HomeController < ApplicationController
  layout :resolve_layout

  def index
    Premailer::Rails::Hook.perform(OrderMailer.send('notify_supplier_after_placed', Order.where(status: :placed).last)).deliver_now
  end

  def retailers; end

  private
  def resolve_layout
    case action_name
    when "index"
      "public/layouts/home"
    else
      "public/layouts/main"
    end
  end
end