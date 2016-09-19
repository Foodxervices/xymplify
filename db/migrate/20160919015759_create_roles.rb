class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name 
      t.belongs_to :restaurant, index: true 
      t.belongs_to :user, index: true
    end
  end
end
