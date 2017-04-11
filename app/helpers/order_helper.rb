module OrderHelper
  include ApplicationHelper
  
  def date_of_delivery(order)
    if order.delivered_at.present?
      format_datetime order.delivered_at
    else
      "#{format_date(order.request_delivery_date)} #{order_time_range(order)}"
    end
  end

  def order_time_range(order)
    "#{[order.start_time, order.end_time].reject(&:blank?).join(' - ')}"
  end
end
