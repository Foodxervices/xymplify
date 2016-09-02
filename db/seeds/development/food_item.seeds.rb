after :supplier do
  puts "==== Create Food Item ===="

  FoodItem.create([
    { code: 'PT90331', name: 'Pasta', unit: 'pack', unit_price: 28.00,  supplier_id: Supplier.order("RANDOM()").first },
    { code: 'EL20920', name: 'Pasta', unit: 'pack', unit_price: 20.00,  supplier_id: Supplier.order("RANDOM()").first }
  ])

  puts "==== End ===="
end
