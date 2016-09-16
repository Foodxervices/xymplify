puts "==== Create Restaurant ===="
Restaurant.create([
  { 
    name: 'Windsor', site_address: 'http://windsoraz.com', billing_address: '18 An Dương Vương, phường 9, Hồ Chí Minh, 67337', contact_person: 'James La', telephone: '+84933557739', email: 'jamesla0604@gmail.com', 
    chickens_attributes: [
      { name: 'Chicken 1' }, 
      { name: 'Chicken 2' }
    ] 
  },
  { 
    name: 'Ai Hue', site_address: 'http://aihue.com', billing_address: '412 418 11 P 11, Q 5, Trần Hưng Đạo, Hồ Chí Minh', contact_person: 'La Hong Phat', telephone: '+84838555802', email: 'phatlh90@gmail.com', 
    chickens_attributes: [
      { name: 'Chicken A' }, 
      { name: 'Chicken B' }
    ] 
  }
])
puts "==== End ===="

