class AddAttachmentsCount < ActiveRecord::Migration
  def self.up
    add_column :food_items, :attachments_count, :integer, :default => 0

    FoodItem.reset_column_information
    FoodItem.all.each do |f|
      FoodItem.update_counters f.id, :attachments_count => f.attachments.length
    end
  end

  def self.down
    remove_column :food_items, :attachments_count
  end
end
