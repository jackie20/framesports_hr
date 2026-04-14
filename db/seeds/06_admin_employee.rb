puts "Seeding admin employee..."

admin_role = Role.find_by!(code: "admin")

admin = Employee.find_or_initialize_by(work_email: "admin@company.com")
if admin.new_record?
  admin.assign_attributes(
    first_name:              "System",
    last_name:               "Administrator",
    employee_number:         "EMP-00001",
    start_date:              Date.today,
    password:                ENV.fetch("ADMIN_SEED_PASSWORD", "Admin@12345!"),
    password_confirmation:   ENV.fetch("ADMIN_SEED_PASSWORD", "Admin@12345!"),
    is_active:               true,
    is_onboarding_complete:  true,
    onboarding_completed_at: Time.current
  )
  admin.save!
  UserRole.find_or_create_by!(employee: admin, role: admin_role) do |ur|
    ur.assigned_at = Time.current
    ur.is_active   = true
  end
  puts "✓ Admin employee created: admin@company.com / #{ENV.fetch('ADMIN_SEED_PASSWORD', 'Admin@12345!')}"
else
  puts "✓ Admin employee already exists"
end

# HR Manager
hr_role = Role.find_by!(code: "hr_manager")
hr = Employee.find_or_initialize_by(work_email: "hr@company.com")
if hr.new_record?
  hr.assign_attributes(
    first_name:             "HR",
    last_name:              "Manager",
    employee_number:        "EMP-00002",
    start_date:             Date.today,
    password:               "HRManager@123!",
    password_confirmation:  "HRManager@123!",
    is_active:              true,
    is_onboarding_complete: true
  )
  dept_lv = LookupType.values_for(:department).find_by(code: "hr")
  hr.department_lookup_id = dept_lv&.id
  hr.save!
  UserRole.find_or_create_by!(employee: hr, role: hr_role) do |ur|
    ur.assigned_at = Time.current
    ur.is_active   = true
  end
  puts "✓ HR Manager created: hr@company.com / HRManager@123!"
else
  puts "✓ HR Manager already exists"
end
