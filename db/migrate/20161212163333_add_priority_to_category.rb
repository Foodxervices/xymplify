class AddPriorityToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :priority, :integer, default: 1
  end
end
