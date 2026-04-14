puts "Seeding roles..."

ROLES = [
  {
    code: "admin", name: "Administrator", is_system: true,
    can_assign_permissions: true,
    description: "Full system access. Can create and manage all roles and permissions."
  },
  {
    code: "hr_manager", name: "HR Manager", is_system: true,
    can_assign_permissions: true,
    description: "Manages employee lifecycle, leave, documents, and teams."
  },
  {
    code: "team_lead", name: "Team Lead", is_system: true,
    can_assign_permissions: false,
    description: "Views team data, approves team leave, manages team tasks."
  },
  {
    code: "employee", name: "Employee", is_system: true,
    can_assign_permissions: false,
    description: "Standard employee. Manages own data."
  },
].freeze

ROLES.each do |attrs|
  Role.find_or_create_by!(code: attrs[:code]) do |r|
    r.name                   = attrs[:name]
    r.description            = attrs[:description]
    r.is_system              = attrs[:is_system]
    r.can_assign_permissions = attrs[:can_assign_permissions]
    r.is_active              = true
  end
  print "."
end

puts "\n✓ Roles seeded"
