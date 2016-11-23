class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.belongs_to :restaurant, index: true
      t.attachment :file 
      t.references :food_item, index: true
    end
  end
end
