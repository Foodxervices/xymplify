puts "==== Destroy Config ===="
Config.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE configs_id_seq RESTART WITH 1"
)
puts "==== End ===="

puts "==== Create Config ===="
Config.create([
  { name: 'Processing Cut-Off', slug: 'cut-off', value: 'On' }
])
puts "==== End ===="

