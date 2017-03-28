puts "==== Destroy User Role ===="
UserRole.destroy_all
ActiveRecord::Base.connection.execute(
  "ALTER SEQUENCE user_roles_id_seq RESTART WITH 1"
)
puts "==== End ===="