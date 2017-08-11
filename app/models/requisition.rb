class Requisition < ActiveRecord::Base
  belongs_to :user
  belongs_to :kitchen
  has_one :restaurant, through: :kitchen
  has_many :items, class_name: 'RequisitionItem', inverse_of: :requisition

  before_create :set_code

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def set_code
    today = Time.new
    current_month = today.strftime("%y/%m")
    latest_order_in_current_month = restaurant.requisitions.where(created_at: today.at_beginning_of_month..today.at_end_of_month).order(:id).last

    if latest_order_in_current_month&.code.nil?
      no = "0001"
    else
      no = (latest_order_in_current_month.code[-4..-1].to_i + 1).to_s.rjust(4,"0")
    end

    self.code = "R" + current_month + '/' + no
  end
end