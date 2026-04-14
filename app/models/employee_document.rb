class EmployeeDocument < ApplicationRecord
  include Discard::Model

  belongs_to :employee
  belongs_to :document_type_lookup, class_name: "LookupValue",
             foreign_key: :document_type_lookup_id
  belongs_to :uploaded_by, class_name: "Employee"
  belongs_to :verified_by, class_name: "Employee", optional: true

  validates :title, :document_type_lookup_id, :uploaded_by_id, presence: true

  scope :not_confidential, -> { where(is_confidential: false) }
  scope :expiring_soon,    -> { where(expiry_date: ..30.days.from_now).where("expiry_date >= ?", Date.today) }
end
