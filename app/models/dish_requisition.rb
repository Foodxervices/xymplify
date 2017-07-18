class DishRequisition < ActiveRecord::Base
  belongs_to :user
  belongs_to :kitchen
  has_many :items, class_name: 'DishRequisitionItem', inverse_of: :dish_requisition

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def price
    items.total_price
  end
end