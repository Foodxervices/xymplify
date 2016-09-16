class CreateChickens < ActiveRecord::Migration
  def change
    create_table :chickens do |t|
      t.string :name
      t.belongs_to :restaurant, index: true
    end
  end
end
