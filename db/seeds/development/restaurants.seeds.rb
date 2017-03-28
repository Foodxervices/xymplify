puts "==== Create Restaurant ===="
Restaurant.create([
  {
    name: 'Saveur Pte Ltd', site_address: 'http://saveur.com', billing_address: '100 Lorong 23 Geylang #09-03', contact_person: 'Eunice Lee', telephone: '97484654', email: 'order@saveur.sg', company_registration_no: 'Co.Reg. No. 201201236Z',
    kitchens_attributes: [
      { name: 'Saveur Art Ion Orchard', address: '2 Orchard Turn, #04-11, ION Orchard, 238801', phone: '90608421', bank_name: 'DBS BANK LTD', bank_address: 'DBS ASIA CENTRAL MBFC TOWER 3, 12 MARINA BOULEVARD', bank_swift_code: 'DBSSSG', bank_account_name: 'SAVEUR PTE LTD', bank_account_number: '123-12345-1' },
      { name: 'Saveur Art Ion Orchard 2', address: '2 Orchard Turn, #04-11, ION Orchard, 238801', phone: '90608421', bank_name: 'DBS BANK LTD', bank_address: 'DBS ASIA CENTRAL MBFC TOWER 3, 12 MARINA BOULEVARD', bank_swift_code: 'DBSSSG', bank_account_name: 'SAVEUR PTE LTD', bank_account_number: '123-12345-1' }
    ]
  },
  {
    name: 'Windsor Pte Ltd', site_address: 'http://windsor.com', billing_address: '100 Lorong 23 Geylang #09-03', contact_person: 'Eunice Lee', telephone: '97484654', email: 'order@windsor.sg', company_registration_no: 'Co.Reg. No. 201201236Z',
    kitchens_attributes: [
      { name: 'Windsor Art Ion Orchard', address: '2 Orchard Turn, #04-11, ION Orchard, 238801', phone: '90608421', bank_name: 'DBS BANK LTD', bank_address: 'DBS ASIA CENTRAL MBFC TOWER 3, 12 MARINA BOULEVARD', bank_swift_code: 'DBSSSG', bank_account_name: 'SAVEUR PTE LTD', bank_account_number: '123-12345-1' },
      { name: 'Windsor Art Ion Orchard 2', address: '2 Orchard Turn, #04-11, ION Orchard, 238801', phone: '90608421', bank_name: 'DBS BANK LTD', bank_address: 'DBS ASIA CENTRAL MBFC TOWER 3, 12 MARINA BOULEVARD', bank_swift_code: 'DBSSSG', bank_account_name: 'SAVEUR PTE LTD', bank_account_number: '123-12345-1' },
    ]
  }
])
puts "==== End ===="

