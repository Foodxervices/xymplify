class DropBanks < ActiveRecord::Migration
  def change
    drop_table :banks
  end
end
