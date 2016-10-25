class Notification
  attr_accessor :current_ability, :restaurant_id, :user_id 

  def initialize(current_ability, restaurant_id, user_id)
    @current_ability = current_ability
    @restaurant_id = restaurant_id
    @user_id   = user_id
  end

  def count
    cache(count_key) {
      alerts = Alert.accessible_by(current_ability, restaurant: restaurant_id)
      alerts = alerts.where('created_at > ?', seen_at) if seen_at.present?
      alerts.count
    }.to_i
  end

  def seen_at
    cache(seen_at_key) {
      Seen.where(restaurant_id: restaurant_id, user_id: user_id).first&.at 
    }
  end

  def seen
    seen = Seen.where(restaurant_id: restaurant_id, user_id: user_id).first_or_create 
    seen.update_column(:at, Time.zone.now)
    clear
  end

  def clear
    $redis.del(seen_at_key)
    $redis.del(count_key)
  end

  private

  def seen_at_key
    "seen_at_#{restaurant_id}_#{user_id}"
  end

  def count_key
    "alert_count_#{restaurant_id}_#{user_id}"
  end

  def cache(key, expire = 1.minutes)
    result = $redis.get(key)

    if result.nil?
      result = yield
      $redis.set(key, result)
      $redis.expire(key, expire)
    end
    result
  end
end
