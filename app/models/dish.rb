class Dish < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user

  after_commit :cache_price, on: [:create, :update]

  monetize :price_cents
  monetize :price_without_profit_cents
  monetize :profit_margin_cents

  has_many :items, class_name: 'DishItem'

  validates :name, presence: true
  validates :profit_margin,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def cache_price
    without_profit = Money.new(items.total_price, restaurant.currency)

    update_columns({
      price_without_profit_cents: without_profit.cents,
      price_without_profit_currency: restaurant.currency,
      price_cents: Money.new(without_profit + profit_margin, restaurant.currency).cents,
      price_currency: restaurant.currency
    })
  end
end