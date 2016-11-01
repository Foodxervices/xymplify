class AddIndexToWhodunnit < ActiveRecord::Migration
  def change
    change_column :versions, :whodunnit, 'integer USING CAST("whodunnit" AS integer)'
    add_index :versions, :whodunnit
  end
end
