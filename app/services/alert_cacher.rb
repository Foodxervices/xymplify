class AlertCacher
  attr_accessor :restaurant_id, :user_id 

  def initialize(restaurant_id, user_id)
    @restaurant_id = restaurant_id
    @user_id   = user_id
  end

  def total_alert
    1
  end
end
