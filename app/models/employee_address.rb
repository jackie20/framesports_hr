class EmployeeAddress < ApplicationRecord
  belongs_to :employee
  belongs_to :address_type_lookup, class_name: "LookupValue",
             foreign_key: :address_type_lookup_id

  validates :line1, :city, :country, presence: true
  validates :address_type_lookup_id, presence: true
end
