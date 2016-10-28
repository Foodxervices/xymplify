class Notification
  attr_accessor :current_ability, :restaurant, :user

  def initialize(current_ability, restaurant, user)
    @current_ability = current_ability
    @restaurant = restaurant
    @user   = user
  end

  def count
    $redis.del(redis_key(:count)) if seen_at < alert_updated_at
    
    cache(:count) {
      alerts = Alert.accessible_by(current_ability, restaurant: restaurant)
      alerts = alerts.where('created_at > ?', seen_at) if seen_at.present?
      alerts.count
    }.to_i
  end

  def seen_at
    $redis.get(redis_key(:seen_at))&.to_datetime || 10.years.ago
  end

  def seen
    $redis.set(redis_key(:seen_at), Time.zone.now)
    $redis.expire(redis_key(:count), 1.seconds)
  end

  def alert_updated_at
    restaurant.redis(:alert_updated_at)&.to_datetime || Time.zone.now
  end

  private

  def redis_key(str)
    "notification:#{restaurant.id}:#{user.id}:#{str}"
  end

  def cache(key, expire = 1.hour)
    key = redis_key(key)
    result = $redis.get(key)

    if result.blank?
      result = yield
      $redis.set(key, result)
      $redis.expire(key, expire)
    end

    result
  end
end
