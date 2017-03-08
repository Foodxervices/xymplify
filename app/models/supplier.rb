class Supplier < ActiveRecord::Base
  extend Enumerize

  default_scope { order(:priority) }

  has_paper_trail :ignore => [:priority, :delivery_days]

  belongs_to :restaurant
  has_many :food_items, :dependent => :restrict_with_error
  has_many :orders,     :dependent => :restrict_with_error
  has_and_belongs_to_many :kitchens

  validates :name,            presence: true
  validates :restaurant_id,   presence: true
  validates :email,           presence: true, email: true
  validates :min_order_price,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }
  validates :max_order_price,  numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }, if: 'max_order_price.present?'

  serialize :delivery_days, Array
  enumerize :delivery_days, in: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday], multiple: true

  has_attached_file :logo, styles: { thumb: "80x80#", medium: "300x300#" }
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  def country_name
    ISO3166::Country[country]
  end

  # when `Processing Cut-Off` is set for supplier as 3pm
  # if the PO is raised before 3pm
  # delivery window can be next day earliest (assume no delivery window constraint)
  # if PO raised after 3pm, delivery window can only be day after earliest (again assume no delivery window constraint)
  def next_available_delivery_date
    now = Time.zone.now
    next_available_date = next_available(now)

    if(!Config.processing_cut_off_enabled? || (processing_cut_off.nil? || now < now.change(hour: processing_cut_off.hour, min: processing_cut_off.min)))
      return next_available_date
    end

    next_available(next_available_date)
  end

  def next_available(date)
    return nil if delivery_days.empty?
    tmr = date.tomorrow.beginning_of_day
    return tmr if valid_delivery_date?(tmr)
    next_available(tmr)
  end

  def valid_delivery_date?(date)
    delivery_days.include?(date.strftime("%A").downcase)
  end
end
