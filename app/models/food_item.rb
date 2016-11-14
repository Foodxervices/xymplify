class FoodItem < ActiveRecord::Base
  acts_as_taggable
  has_paper_trail

  self.inheritance_column = :_type_disabled
  
  monetize :unit_price_cents
  monetize :unit_price_without_promotion_cents

  before_create :cache_restaurant
  before_save :set_category_and_tags

  belongs_to :supplier
  belongs_to :user
  belongs_to :kitchen
  belongs_to :restaurant
  belongs_to :category

  has_many :alerts, as: :alertable
  
  validates_associated :supplier, :user, :kitchen, :category

  validates :code,        presence: true, uniqueness: {scope: [:kitchen_id]}
  validates :name,        presence: true 
  validates :brand,       presence: true
  validates :supplier_id, presence: true
  validates :user_id,     presence: true
  validates :kitchen_id,  presence: true
  validates :unit_price,  presence: true, numericality: { greater_than: 0 }
  validates :unit_price_currency,                    presence: true
  validates :unit_price_without_promotion,           presence: true, numericality: { greater_than: 0 }
  validates :unit_price_without_promotion_currency,  presence: true
  validates :current_quantity,  presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_ordered,  presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :low_quantity,                      numericality: { greater_than_or_equal_to: 0 }, :allow_blank => true

  has_attached_file :image, styles: { thumb: "80x80#", medium: "400x400#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_validation :set_currency

  def has_special_price?
    unit_price != unit_price_without_promotion
  end

  private 
  def set_currency
    self.unit_price_currency = supplier&.currency if unit_price_currency.blank?
    self.unit_price_without_promotion_currency = unit_price_currency if unit_price_without_promotion_currency != unit_price_currency
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