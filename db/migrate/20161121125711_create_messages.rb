class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :restaurant, index: true
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
