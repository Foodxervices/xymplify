class AddTimestampsToSuppliers < ActiveRecord::Migration
  def change
    add_timestamps :suppliers, null: false, default: DateTime.now

    Supplier.all.each do |s|
      s.update_columns(created_at: s.versions.first.created_at, updated_at: s.versions.last.created_at)
    end
  end
end
