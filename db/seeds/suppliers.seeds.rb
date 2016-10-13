after [:restaurants] do 
  puts "==== Destroy Supplier ===="
  Supplier.destroy_all
  ActiveRecord::Base.connection.execute(
    "ALTER SEQUENCE suppliers_id_seq RESTART WITH 1"
  )
  puts "==== End ===="

  Restaurant.all.each do |restaurant|
    restaurant.suppliers.create([
      { name: 'Foodxervices inc pte ltd', address: '39 KEPPEL ROAD, #01-02/04 TANJONG PAGAR DISTRIPARK, SINGAPORE 089065', contact: 'James La', telephone: '1800 933 3333' },
      { name: 'Vinamilk inc pte ltd', address: '39 KEPPEL ROAD, #01-02/04 TANJONG PAGAR DISTRIPARK, SINGAPORE 089065', contact: 'James La', telephone: '1800 933 3333', currency: 'VND' }
    ])
  end
end