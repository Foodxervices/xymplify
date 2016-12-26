class Config < ActiveRecord::Base
  validates :name,      presence: true
  validates :slug,      presence: true
  validates :value,     presence: true

  after_save :cache_redis

  def self.processing_cut_off_enabled?
    $redis.get("config:cut-off") == 'On'
  end

  protected 
  def cache_redis
    $redis.set("config:#{slug}", value)
  end
end