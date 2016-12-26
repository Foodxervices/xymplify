class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :name
      t.string :slug, index: true 
      t.string :value
    end
  end
end
