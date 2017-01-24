module OrderHelper
  def date_of_delivery(order)
    if order.delivered_at.present?
      format_datetime order.delivered_at
    else
      "#{format_datetime(order.request_for_delivery_start_at)} - #{format_datetime(order.request_for_delivery_end_at)}"
    end
  end
end
