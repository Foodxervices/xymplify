class FoodItem < ActiveRecord::Base
  acts_as_taggable
  has_paper_trail

  self.inheritance_column = :_type_disabled
  
  monetize :unit_price_cents

  before_create :cache_restaurant
  before_save :set_category_and_tags

  belongs_to :supplier
  belongs_to :user
  belongs_to :kitchen
  belongs_to :restaurant
  belongs_to :category

  has_many :alerts, as: :alertable
  
  validates_associated :supplier, :user, :kitchen, :category

  validates :code,        presence: true
  validates :name,        presence: true 
  validates :unit_price,  presence: true
  validates :brand,       presence: true
  validates :supplier_id, presence: true
  validates :user_id,     presence: true
  validates :kitchen_id,  presence: true
  validates :unit_price_currency, presence: true
  validates :current_quantity,  presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_ordered,  presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :low_quantity,                      numericality: { greater_than_or_equal_to: 0 }, :allow_blank => true

  has_attached_file :image, styles: { thumb: "80x80#", medium: "400x400#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_validation :set_currency, if: 'unit_price_currency.blank?'

  private 
  def set_currency
    self.unit_price_currency = supplier&.currency 
  end

  def cache_restaurant
    self.restaurant_id = kitchen.restaurant_id
  end

  def set_category_and_tags
    if category_id.blank?
      self.category_id = Category.find_or_create_by(name: 'Uncategorised').id 
    end

    if tag_list.blank?
      self.tag_list = 'Others'
    end
  end
end