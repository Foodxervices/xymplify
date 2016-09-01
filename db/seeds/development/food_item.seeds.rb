puts "==== DEVELOPMENT: Create FAQs ===="

FoodItem.create([
  { code: 'PT90331', name: 'Pasta', unit: 'pack', unit_price: 28.00 },
  { code: 'EL20920', name: 'Pasta', unit: 'pack', unit_price: 20.00 }
])

puts "==== End ===="