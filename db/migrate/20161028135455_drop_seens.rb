class DropSeens < ActiveRecord::Migration
  def change
    drop_table :seens
  end
end
