class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :subject_class
      t.string :action
      t.text :description

      t.timestamps null: false
    end
  end
end
