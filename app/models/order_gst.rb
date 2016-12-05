class OrderGst < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :order, :counter_cache => :gsts_count
  belongs_to :restaurant
  belongs_to :kitchen

  before_create :cache_restaurant

  validates :name,      presence: true
  validates :percent,   presence: true, numericality: { greater_than: 0, less_than: 100 }

  def amount 
    order.price * percent / 100
  end

  def self.amount 
    all.includes(:order).map(&:amount).inject(0, :+)
  end

  private 
  def cache_restaurant
    self.restaurant_id = order.restaurant_id 
    self.kitchen_id = order.kitchen_id 
  end
end