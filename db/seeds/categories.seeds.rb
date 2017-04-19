puts "==== Destroy Food Item ===="
Category.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE categories_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Category ===="
Category.create([
  { name: 'FRESH FRUITS' },
  { name: 'FRESH MEATS' },
  { name: 'FRESH VEGETABLES' },
  { name: 'DRESSINGS' },
  { name: 'MUSTARDS' },
  { name: 'PASTES & PUREES' },
  { name: 'SAUCES FOR COOKING' },
  { name: 'SAUCES FOR TABLE TOPS' },
  { name: 'ADDITIVES & PRESERVATIVES' },
  { name: 'COLOURINGS & ESSENCES' },
  { name: 'SALTS' },
  { name: 'BEVERAGES - READY TO DRINK' },
  { name: 'HOT BEVERAGES & MIXES' },
  { name: 'CANNED BEANS' },
  { name: 'CANNED FRUITS' },
  { name: 'CANNED MEATS & SEAFOOD' },
  { name: 'CANNED VEGETABLES' },
  { name: 'DAIRY' },
  { name: 'DRIED BEANS' },
  { name: 'DRIED FRUITS' },
  { name: 'DRIED MEATS & SEAFOOD' },
  { name: 'DRIED VEGETABLES' },
  { name: 'NUTS' },
  { name: 'FROZEN - GENERAL' },
  { name: 'FROZEN MEATS & VEGETABLES' },
  { name: 'CHINESE HERBS' },
  { name: 'SPICES' },
  { name: 'WESTERN HERBS' },
  { name: 'CLEANING' },
  { name: 'PACKAGING & OTHERS' },
  { name: 'OILS & FATS' },
  { name: 'PRESERVED FOOD - WESTERN' },
  { name: 'PRESERVED FOOD - ASIAN' },
  { name: 'BREADS & WRAPS' },
  { name: 'CEREALS & GRAINS' },
  { name: 'CONFECTIONERIES' },
  { name: 'FLOURS & PRE-MIXES' },
  { name: 'NOODLES' },
  { name: 'PASTAS' },
  { name: 'RICE' },
  { name: 'CONDIMENTS & SUNDRIES' },
  { name: 'HONEY & SYRUP TOPPINGS' },
  { name: 'SPREADS & FILLINGS' },
  { name: 'SUGARS' },
  { name: 'DESSERT INGREDIENTS' },
  { name: 'VINEGARS' },
  { name: 'WINES' },
  { name: 'Uncategorised', priority: 101 },
  { name: 'Others', priority: 102 }
])
puts "==== End ===="



