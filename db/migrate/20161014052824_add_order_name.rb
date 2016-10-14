class AddOrderName < ActiveRecord::Migration
  def change
    add_column :orders, :name, :string

    Order.all.each do |order|
      order.save
    end
  end
end
