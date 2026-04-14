class LeaveBalance < ApplicationRecord
  belongs_to :employee
  belongs_to :leave_type_lookup, class_name: "LookupValue",
             foreign_key: :leave_type_lookup_id

  validates :year, :total_days, presence: true
  validates :employee_id, uniqueness: { scope: [:leave_type_lookup_id, :year] }

  def available_days
    total_days + carried_over_days - used_days - pending_days
  end
end
