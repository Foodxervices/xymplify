after "development:suppliers", "development:users" do 
  puts "==== Create Food Item ===="

  FoodItem.create([
    { code: 'PT90331', name: 'Pasta', unit: 'pack',   unit_price: 28.00,  supplier: Supplier.order("RANDOM()").first, user: User.first },
    { code: 'EL20920', name: 'Pex',   unit: 'kg',     unit_price: 24.05,  supplier: Supplier.order("RANDOM()").first, user: User.first },
    { code: 'PT90332', name: 'Noce',  unit: 'litre',  unit_price: 28.00,  supplier: Supplier.order("RANDOM()").first, user: User.first },
    { code: 'EL20923', name: 'Trea',  unit: 'pack',   unit_price: 23.00,  supplier: Supplier.order("RANDOM()").first, user: User.first },
    { code: 'PT90334', name: 'Stres', unit: 'can',    unit_price: 28.00,  supplier: Supplier.order("RANDOM()").first, user: User.first },
    { code: 'EL20925', name: 'Point', unit: 'pack',   unit_price: 22.33,  supplier: Supplier.order("RANDOM()").first, user: User.first },
    { code: 'PT90336', name: 'Nuin',  unit: 'litre',  unit_price: 68.00,  supplier: Supplier.order("RANDOM()").first, user: User.first },
    { code: 'EL20927', name: 'Seter', unit: 'pack',   unit_price: 30.05,  supplier: Supplier.order("RANDOM()").first, user: User.first },
  ])

  puts "==== End ===="
end
