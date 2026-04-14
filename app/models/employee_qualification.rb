class EmployeeQualification < ApplicationRecord
  belongs_to :employee
  belongs_to :qualification_type_lookup, class_name: "LookupValue",
             foreign_key: :qualification_type_lookup_id
  belongs_to :verified_by, class_name: "Employee", optional: true

  validates :institution_name, :qualification_name, :qualification_type_lookup_id, presence: true
end
