puts "==== Destroy Food Item ===="
Category.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE categories_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Category ===="
Category.create([
  { name: 'Additives & Colourings' },
  { name: 'Beverages' },
  { name: 'Canned' },
  { name: 'Dairy' },
  { name: 'Disposables & Non-food' },
  { name: 'Dried' },
  { name: 'Frozen' },
  { name: 'Fruits & Vegetables' },
  { name: 'Herbs & Spices' },
  { name: 'Meat & Seafood' },
  { name: 'Oils & Fats' },
  { name: 'Preserved' },
  { name: 'Salts & Seasonings' },
  { name: 'Sauces & Dressings' },
  { name: 'Staples' },
  { name: 'Sugar, Spreads & Syrups' },
  { name: 'Vinegars & Wines' },
  { name: 'Uncategorised', priority: 101 },
  { name: 'Others', priority: 102 }
])
puts "==== End ===="