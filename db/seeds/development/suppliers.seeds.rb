after [:'development:restaurants'] do
  Restaurant.all.each do |restaurant|
    restaurant.suppliers.create([
      { name: 'Foodxervices inc pte ltd', address: '39 KEPPEL ROAD, #01-02/04 TANJONG PAGAR DISTRIPARK, SINGAPORE 089065', contact: 'James La', telephone: '1800 933 3333', company_registration_no: 'Co.Reg. No. 201201236Z' },
      { name: 'Vinamilk inc pte ltd', address: '39 KEPPEL ROAD, #01-02/04 TANJONG PAGAR DISTRIPARK, SINGAPORE 089065', contact: 'James La', telephone: '1800 933 3333', currency: 'VND', company_registration_no: 'Co.Reg. No. 201201236Z' }
    ])
  end
end