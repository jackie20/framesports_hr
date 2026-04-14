puts "Seeding teams..."

admin = Employee.find_by!(work_email: "admin@company.com")

TEAMS = [
  { code: "executive",  name: "Executive",  description: "Executive leadership team" },
  { code: "hr",         name: "Human Resources", description: "HR department team" },
  { code: "it",         name: "Information Technology", description: "IT department team" },
  { code: "finance",    name: "Finance",    description: "Finance department team" },
  { code: "operations", name: "Operations", description: "Operations department team" },
].freeze

TEAMS.each do |attrs|
  Team.find_or_create_by!(code: attrs[:code]) do |t|
    t.name           = attrs[:name]
    t.description    = attrs[:description]
    t.is_active      = true
    t.created_by     = admin
    t.team_lead      = admin if attrs[:code] == "executive"
  end
  print "."
end

# Add HR manager to the HR team
hr_team   = Team.find_by!(code: "hr")
hr_emp    = Employee.find_by(work_email: "hr@company.com")
if hr_emp && !TeamMember.exists?(team: hr_team, employee: hr_emp)
  TeamMember.create!(
    team:       hr_team,
    employee:   hr_emp,
    role_title: "HR Manager",
    joined_at:  Date.today,
    is_active:  true
  )
end

puts "\n✓ Teams seeded"
