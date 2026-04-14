Rails.logger.info "=== Seeding EOMS Database ==="
puts "Starting EOMS seed process..."

[
  "db/seeds/01_lookup_types.rb",
  "db/seeds/02_lookup_values.rb",
  "db/seeds/03_permissions.rb",
  "db/seeds/04_roles.rb",
  "db/seeds/05_role_permissions.rb",
  "db/seeds/06_admin_employee.rb",
  "db/seeds/07_teams.rb",
].each do |seed_file|
  puts "\n--- #{seed_file} ---"
  load Rails.root.join(seed_file)
end

puts "\n=== Seeding Complete ==="
puts "Summary:"
puts "  LookupTypes:  #{LookupType.count}"
puts "  LookupValues: #{LookupValue.count}"
puts "  Permissions:  #{Permission.count}"
puts "  Roles:        #{Role.count}"
puts "  Employees:    #{Employee.count}"
puts "  Teams:        #{Team.count}"
