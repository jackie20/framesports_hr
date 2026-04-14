class EmployeeUniform < ApplicationRecord
  belongs_to :employee
  belongs_to :shirt_size_lookup,       class_name: "LookupValue", optional: true,
             foreign_key: :shirt_size_lookup_id
  belongs_to :jacket_size_lookup,      class_name: "LookupValue", optional: true,
             foreign_key: :jacket_size_lookup_id
  belongs_to :dress_size_lookup,       class_name: "LookupValue", optional: true,
             foreign_key: :dress_size_lookup_id
  belongs_to :shoe_size_system_lookup, class_name: "LookupValue", optional: true,
             foreign_key: :shoe_size_system_lookup_id
  belongs_to :glove_size_lookup,       class_name: "LookupValue", optional: true,
             foreign_key: :glove_size_lookup_id
end
