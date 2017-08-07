class Dish < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :restaurant
  belongs_to :user

  monetize :price_cents
  monetize :price_without_profit_cents
  monetize :profit_margin_cents

  has_many :items, class_name: 'DishItem'

  validates :name, presence: true
  validates :profit_margin,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def price_without_profit
    @without_profit ||= Money.new(items.total_price, restaurant.currency)
  end

  def price
    @price ||= Money.new(price_without_profit + profit_margin, restaurant.currency)
  end
end