class AddPriorityToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :priority, :integer, index: true, default: 1
  end
end
