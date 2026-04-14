puts "Seeding lookup types..."

LOOKUP_TYPES = [
  { code: "title",               name: "Employee Title",      is_system: true  },
  { code: "gender",              name: "Gender",              is_system: true  },
  { code: "marital_status",      name: "Marital Status",      is_system: true  },
  { code: "document_type",       name: "Document Type",       is_system: true  },
  { code: "leave_type",          name: "Leave Type",          is_system: true  },
  { code: "leave_status",        name: "Leave Status",        is_system: true  },
  { code: "address_type",        name: "Address Type",        is_system: true  },
  { code: "clothing_size",       name: "Clothing Size",       is_system: false },
  { code: "shoe_size_system",    name: "Shoe Size System",    is_system: false },
  { code: "qualification_type",  name: "Qualification Type",  is_system: false },
  { code: "relationship_type",   name: "Relationship Type",   is_system: true  },
  { code: "file_category",       name: "File Category",       is_system: false },
  { code: "task_status",         name: "Task Status",         is_system: true  },
  { code: "task_priority",       name: "Task Priority",       is_system: true  },
  { code: "notification_type",   name: "Notification Type",   is_system: true  },
  { code: "employment_type",     name: "Employment Type",     is_system: true  },
  { code: "department",          name: "Department",          is_system: false },
].freeze

LOOKUP_TYPES.each_with_index do |attrs, idx|
  LookupType.find_or_create_by!(code: attrs[:code]) do |lt|
    lt.name       = attrs[:name]
    lt.is_system  = attrs[:is_system]
    lt.is_active  = true
    lt.sort_order = idx
  end
  print "."
end

puts "\n✓ LookupTypes seeded (#{LOOKUP_TYPES.length})"
