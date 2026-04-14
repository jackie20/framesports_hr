puts "Seeding role permissions..."

ROLE_PERMISSIONS = {
  "admin" => :all,
  "hr_manager" => [
    "employees.view_all", "employees.create", "employees.update_all", "employees.delete", "employees.view_sensitive",
    "leave.view_all", "leave.approve", "leave.manage",
    "documents.view_all", "documents.upload_own", "documents.delete_all",
    "files.view", "files.upload", "files.manage_categories",
    "tasks.view_all", "tasks.create", "tasks.assign", "tasks.manage",
    "chat.participate", "chat.create_room",
    "reports.view_all", "reports.view_team", "reports.export",
    "admin.roles.view", "admin.lookups.manage", "admin.teams.manage", "admin.users.assign_roles",
  ],
  "team_lead" => [
    "employees.view_all",
    "leave.view_team", "leave.approve",
    "documents.view_own",
    "files.view", "files.upload",
    "tasks.view_team", "tasks.create", "tasks.assign", "tasks.update_own",
    "chat.participate", "chat.create_room",
    "reports.view_team",
  ],
  "employee" => [
    "employees.view_own", "employees.update_own",
    "leave.request", "leave.view_own",
    "documents.upload_own", "documents.view_own", "documents.delete_own",
    "files.view",
    "tasks.view_own", "tasks.update_own",
    "chat.participate",
    "reports.view_self",
  ],
}.freeze

all_permissions = Permission.all.index_by(&:code)

ROLE_PERMISSIONS.each do |role_code, permissions|
  role = Role.find_by!(code: role_code)
  perm_list = permissions == :all ? all_permissions.values : permissions.map { |code| all_permissions[code] }.compact

  perm_list.each do |perm|
    RolePermission.find_or_create_by!(role: role, permission: perm) do |rp|
      rp.granted_at = Time.current
    end
    print "."
  end
end

puts "\n✓ Role permissions seeded"
