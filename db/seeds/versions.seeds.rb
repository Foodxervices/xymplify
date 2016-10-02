puts "==== Destroy Version ===="
Version.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE versions_id_seq RESTART WITH 1"
)
puts "==== End ===="