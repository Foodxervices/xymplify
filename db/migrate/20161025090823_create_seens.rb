class CreateSeens < ActiveRecord::Migration
  def change
    create_table :seens do |t|
      t.belongs_to :user, index: true
      t.belongs_to :restaurant, index: true
      t.datetime :at
    end
  end
end
