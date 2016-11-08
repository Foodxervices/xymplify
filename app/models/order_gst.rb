class OrderGst < ActiveRecord::Base
  has_paper_trail

  monetize :amount_cents
  
  belongs_to :order, :counter_cache => :gsts_count
  belongs_to :restaurant

  before_create :cache_restaurant
  before_save :cache_amount

  validates :name,      presence: true
  validates :percent,   presence: true, numericality: { greater_than: 0, less_than: 100 }

  def self.amount 
    all.map(&:amount).inject(0, :+)
  end

  private 
  def cache_restaurant
    self.restaurant_id = order.restaurant_id 
  end

  def cache_amount
    self.amount = order.price * percent / 100
  end
end