class AddCodeForDish < ActiveRecord::Migration
  def change
    add_column :dish_requisitions, :code, :string
    add_column :requisitions, :code, :string

    DishRequisition.all.each do |requisition|
      requisition.set_code
      requisition.save
    end

    Requisition.all.each do |requisition|
      requisition.set_code
      requisition.save
    end
  end
end
