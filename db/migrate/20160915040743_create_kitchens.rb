class CreateKitchens < ActiveRecord::Migration
  def change
    create_table :kitchens do |t|
      t.string :name
      t.belongs_to :restaurant, index: true
    end
  end
end
