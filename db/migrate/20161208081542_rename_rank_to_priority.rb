class RenameRankToPriority < ActiveRecord::Migration
  def change
    remove_column :suppliers, :rank 
    add_column :suppliers, :priority, :integer, index: true
  end
end
