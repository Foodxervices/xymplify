class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :title
      t.references :alertable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
