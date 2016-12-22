class Add < ActiveRecord::Migration
  def change
    add_column :suppliers, :processing_cut_off, :time
  end
end
