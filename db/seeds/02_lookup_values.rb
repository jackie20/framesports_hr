puts "Seeding lookup values..."

LOOKUP_VALUES = {
  "title" => [
    { code: "mr",   value: "Mr",   sort_order: 1 },
    { code: "mrs",  value: "Mrs",  sort_order: 2 },
    { code: "ms",   value: "Ms",   sort_order: 3 },
    { code: "dr",   value: "Dr",   sort_order: 4 },
    { code: "prof", value: "Prof", sort_order: 5 },
    { code: "rev",  value: "Rev",  sort_order: 6 },
  ],
  "gender" => [
    { code: "male",            value: "Male",            sort_order: 1 },
    { code: "female",          value: "Female",          sort_order: 2 },
    { code: "non_binary",      value: "Non-binary",      sort_order: 3 },
    { code: "prefer_not_say",  value: "Prefer not to say", sort_order: 4 },
  ],
  "marital_status" => [
    { code: "single",   value: "Single",   sort_order: 1 },
    { code: "married",  value: "Married",  sort_order: 2 },
    { code: "divorced", value: "Divorced", sort_order: 3 },
    { code: "widowed",  value: "Widowed",  sort_order: 4 },
  ],
  "document_type" => [
    { code: "national_id",       value: "National ID",        sort_order: 1 },
    { code: "passport",          value: "Passport",           sort_order: 2 },
    { code: "drivers_licence",   value: "Driver's Licence",   sort_order: 3 },
    { code: "tax_certificate",   value: "Tax Certificate",    sort_order: 4 },
    { code: "matric_certificate", value: "Matric Certificate", sort_order: 5 },
    { code: "degree",            value: "Degree",             sort_order: 6 },
    { code: "diploma",           value: "Diploma",            sort_order: 7 },
    { code: "other",             value: "Other",              sort_order: 99 },
  ],
  "leave_type" => [
    { code: "annual",                value: "Annual Leave",                sort_order: 1 },
    { code: "sick",                  value: "Sick Leave",                  sort_order: 2 },
    { code: "maternity",             value: "Maternity Leave",             sort_order: 3 },
    { code: "paternity",             value: "Paternity Leave",             sort_order: 4 },
    { code: "unpaid",                value: "Unpaid Leave",                sort_order: 5 },
    { code: "study",                 value: "Study Leave",                 sort_order: 6 },
    { code: "family_responsibility", value: "Family Responsibility Leave", sort_order: 7 },
  ],
  "leave_status" => [
    { code: "pending",   value: "Pending",   sort_order: 1 },
    { code: "approved",  value: "Approved",  sort_order: 2 },
    { code: "rejected",  value: "Rejected",  sort_order: 3 },
    { code: "cancelled", value: "Cancelled", sort_order: 4 },
  ],
  "address_type" => [
    { code: "home",        value: "Home",         sort_order: 1 },
    { code: "postal",      value: "Postal",       sort_order: 2 },
    { code: "work",        value: "Work",         sort_order: 3 },
    { code: "next_of_kin", value: "Next of Kin",  sort_order: 4 },
  ],
  "clothing_size" => [
    { code: "xs",   value: "XS",   sort_order: 1 },
    { code: "s",    value: "S",    sort_order: 2 },
    { code: "m",    value: "M",    sort_order: 3 },
    { code: "l",    value: "L",    sort_order: 4 },
    { code: "xl",   value: "XL",   sort_order: 5 },
    { code: "xxl",  value: "XXL",  sort_order: 6 },
    { code: "xxxl", value: "XXXL", sort_order: 7 },
  ],
  "shoe_size_system" => [
    { code: "uk", value: "UK", sort_order: 1 },
    { code: "us", value: "US", sort_order: 2 },
    { code: "eu", value: "EU", sort_order: 3 },
    { code: "cm", value: "CM", sort_order: 4 },
  ],
  "qualification_type" => [
    { code: "matric",      value: "Matric",      sort_order: 1 },
    { code: "certificate", value: "Certificate", sort_order: 2 },
    { code: "diploma",     value: "Diploma",     sort_order: 3 },
    { code: "degree",      value: "Degree",      sort_order: 4 },
    { code: "honours",     value: "Honours",     sort_order: 5 },
    { code: "masters",     value: "Masters",     sort_order: 6 },
    { code: "doctorate",   value: "Doctorate",   sort_order: 7 },
    { code: "trade",       value: "Trade",       sort_order: 8 },
  ],
  "relationship_type" => [
    { code: "reports_to", value: "Reports To", sort_order: 1 },
    { code: "manages",    value: "Manages",    sort_order: 2 },
    { code: "peer",       value: "Peer",       sort_order: 3 },
    { code: "mentor",     value: "Mentor",     sort_order: 4 },
    { code: "mentee",     value: "Mentee",     sort_order: 5 },
  ],
  "file_category" => [
    { code: "policy",       value: "Policy",       sort_order: 1 },
    { code: "onboarding",   value: "Onboarding",   sort_order: 2 },
    { code: "contract",     value: "Contract",     sort_order: 3 },
    { code: "announcement", value: "Announcement", sort_order: 4 },
    { code: "training",     value: "Training",     sort_order: 5 },
  ],
  "task_status" => [
    { code: "open",        value: "Open",        sort_order: 1 },
    { code: "in_progress", value: "In Progress", sort_order: 2 },
    { code: "on_hold",     value: "On Hold",     sort_order: 3 },
    { code: "completed",   value: "Completed",   sort_order: 4 },
    { code: "cancelled",   value: "Cancelled",   sort_order: 5 },
  ],
  "task_priority" => [
    { code: "low",      value: "Low",      sort_order: 1 },
    { code: "medium",   value: "Medium",   sort_order: 2 },
    { code: "high",     value: "High",     sort_order: 3 },
    { code: "critical", value: "Critical", sort_order: 4 },
  ],
  "notification_type" => [
    { code: "system",   value: "System",   sort_order: 1 },
    { code: "task",     value: "Task",     sort_order: 2 },
    { code: "leave",    value: "Leave",    sort_order: 3 },
    { code: "chat",     value: "Chat",     sort_order: 4 },
    { code: "document", value: "Document", sort_order: 5 },
    { code: "report",   value: "Report",   sort_order: 6 },
  ],
  "employment_type" => [
    { code: "permanent",  value: "Permanent",    sort_order: 1 },
    { code: "contract",   value: "Contract",     sort_order: 2 },
    { code: "part_time",  value: "Part-time",    sort_order: 3 },
    { code: "intern",     value: "Intern",       sort_order: 4 },
    { code: "probation",  value: "Probation",    sort_order: 5 },
  ],
  "department" => [
    { code: "hr",         value: "HR",         sort_order: 1 },
    { code: "finance",    value: "Finance",    sort_order: 2 },
    { code: "it",         value: "IT",         sort_order: 3 },
    { code: "operations", value: "Operations", sort_order: 4 },
    { code: "sales",      value: "Sales",      sort_order: 5 },
    { code: "legal",      value: "Legal",      sort_order: 6 },
    { code: "executive",  value: "Executive",  sort_order: 7 },
  ],
}.freeze

LOOKUP_VALUES.each do |type_code, values|
  type = LookupType.find_by!(code: type_code)
  values.each do |attrs|
    LookupValue.find_or_create_by!(lookup_type: type, code: attrs[:code]) do |lv|
      lv.value      = attrs[:value]
      lv.sort_order = attrs[:sort_order]
      lv.is_active  = true
    end
    print "."
  end
end

puts "\n✓ LookupValues seeded"
