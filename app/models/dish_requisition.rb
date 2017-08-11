class DishRequisition < ActiveRecord::Base
  monetize :price_cents

  belongs_to :user
  belongs_to :kitchen
  has_one :restaurant, through: :kitchen
  has_many :items, class_name: 'DishRequisitionItem', inverse_of: :dish_requisition

  after_commit :cache_price, on: [:create, :update]

  before_create :set_code

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def cache_price
    update_columns({
      price_cents: Money.new(items.total_price, restaurant.currency).cents,
      price_currency: restaurant.currency
    })
  end

  private 

  def set_code
    today = Time.new
    current_month = today.strftime("%y/%m")
    latest_order_in_current_month = restaurant.dish_requisitions.where(created_at: today.at_beginning_of_month..today.at_end_of_month).order(:id).last

    if latest_order_in_current_month&.code.nil?
      no = "0001"
    else
      no = (latest_order_in_current_month.code[-4..-1].to_i + 1).to_s.rjust(4,"0")
    end

    self.code = "P" + current_month + '/' + no
  end
end