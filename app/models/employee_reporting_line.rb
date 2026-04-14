class EmployeeReportingLine < ApplicationRecord
  belongs_to :employee,                class_name: "Employee"
  belongs_to :reports_to,              class_name: "Employee"
  belongs_to :relationship_type_lookup, class_name: "LookupValue",
             foreign_key: :relationship_type_lookup_id
  belongs_to :created_by,             class_name: "Employee", optional: true

  validates :effective_from, presence: true
  validates :relationship_type_lookup_id, presence: true

  scope :active,   -> { where("effective_to IS NULL OR effective_to >= ?", Date.today) }
  scope :primary,  -> { where(is_primary: true) }
end
