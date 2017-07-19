class DishRequisition < ActiveRecord::Base
  monetize :price_cents

  belongs_to :user
  belongs_to :kitchen
  has_one :restaurant, through: :kitchen
  has_many :items, class_name: 'DishRequisitionItem', inverse_of: :dish_requisition

  after_commit :cache_price, on: [:create, :update]

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def cache_price
    update_columns({
      price_cents: Money.new(items.total_price, restaurant.currency).cents,
      price_currency: restaurant.currency
    })
  end
end