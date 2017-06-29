class Requisition < ActiveRecord::Base
  belongs_to :user
  belongs_to :kitchen
  has_many :items, class_name: 'RequisitionItem', inverse_of: :requisition

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end