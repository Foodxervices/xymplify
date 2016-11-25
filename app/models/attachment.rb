class Attachment < ActiveRecord::Base
  has_paper_trail :if => Proc.new { |attachment| attachment.food_item_id.present? }

  belongs_to :restaurant
  belongs_to :food_item, :counter_cache => :attachments_count
  has_attached_file :file
  validates_attachment :file,
                       :content_type => { :content_type => Rails.application.config.upload_file_type },
                       :size => { :less_than => 5.megabyte }
  before_post_process { false }

  before_save :cache_restaurant

  def name
    file_file_name
  end

  def cache_restaurant
    self.restaurant_id = food_item.restaurant_id if restaurant_id.nil? && food_item.present?
  end
end