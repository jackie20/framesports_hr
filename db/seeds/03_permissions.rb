puts "Seeding permissions..."

PERMISSIONS = {
  "employees" => [
    ["employees.view_own",       "View Own Profile"],
    ["employees.view_all",       "View All Employees"],
    ["employees.create",         "Create Employees"],
    ["employees.update_own",     "Update Own Profile"],
    ["employees.update_all",     "Update Any Employee"],
    ["employees.delete",         "Delete Employees"],
    ["employees.view_sensitive", "View Sensitive Employee Data"],
  ],
  "leave" => [
    ["leave.request",   "Submit Leave Requests"],
    ["leave.view_own",  "View Own Leave"],
    ["leave.view_team", "View Team Leave"],
    ["leave.view_all",  "View All Leave"],
    ["leave.approve",   "Approve / Reject Leave"],
    ["leave.manage",    "Full Leave Administration"],
  ],
  "documents" => [
    ["documents.upload_own",  "Upload Own Documents"],
    ["documents.view_own",    "View Own Documents"],
    ["documents.view_all",    "View All Employee Documents"],
    ["documents.delete_own",  "Delete Own Documents"],
    ["documents.delete_all",  "Delete Any Document"],
  ],
  "files" => [
    ["files.view",             "View Shared Files"],
    ["files.upload",           "Upload Shared Files"],
    ["files.delete_own",       "Delete Own Uploads"],
    ["files.delete_all",       "Delete Any File"],
    ["files.manage_categories", "Manage File Categories"],
  ],
  "tasks" => [
    ["tasks.view_own",   "View Own Assigned Tasks"],
    ["tasks.view_team",  "View Team Tasks"],
    ["tasks.view_all",   "View All Tasks"],
    ["tasks.create",     "Create Tasks"],
    ["tasks.assign",     "Assign Tasks to Others"],
    ["tasks.update_own", "Update Own Tasks"],
    ["tasks.manage",     "Full Task Management"],
  ],
  "chat" => [
    ["chat.participate",  "Use Chat"],
    ["chat.create_room",  "Create Chat Rooms"],
    ["chat.manage",       "Moderate Chat"],
  ],
  "reports" => [
    ["reports.view_self", "View Personal Reports"],
    ["reports.view_team", "View Team Reports"],
    ["reports.view_all",  "View Organisation Reports"],
    ["reports.export",    "Export Reports"],
  ],
  "admin" => [
    ["admin.roles.view",               "View Roles"],
    ["admin.roles.create",             "Create Roles"],
    ["admin.roles.update",             "Update Roles"],
    ["admin.roles.delete",             "Delete Roles"],
    ["admin.roles.assign_permissions", "Assign Permissions to Roles"],
    ["admin.users.assign_roles",       "Assign Roles to Employees"],
    ["admin.lookups.manage",           "Manage Lookups"],
    ["admin.teams.manage",             "Manage Teams"],
    ["admin.system",                   "Full System Access"],
  ],
}.freeze

PERMISSIONS.each do |category, perms|
  perms.each do |code, name|
    Permission.find_or_create_by!(code: code) do |p|
      p.name      = name
      p.category  = category
      p.is_system = true
    end
    print "."
  end
end

puts "\n✓ Permissions seeded (#{Permission.count})"
