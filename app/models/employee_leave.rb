class EmployeeLeave < ApplicationRecord
  belongs_to :employee
  belongs_to :leave_type_lookup, class_name: "LookupValue",
             foreign_key: :leave_type_lookup_id
  belongs_to :status_lookup,     class_name: "LookupValue",
             foreign_key: :status_lookup_id
  belongs_to :reviewer,          class_name: "Employee", optional: true

  validates :start_date, :end_date, :days_requested, :leave_type_lookup_id, presence: true
  validate  :end_date_after_start_date

  scope :pending,  -> { joins(:status_lookup).where(lookup_values: { code: "pending" }) }
  scope :approved, -> { joins(:status_lookup).where(lookup_values: { code: "approved" }) }
  scope :for_year, ->(year) { where("YEAR(start_date) = ?", year) }

  def pending?
    status_lookup&.code == "pending"
  end

  def approved?
    status_lookup&.code == "approved"
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, "must be on or after start date") if end_date < start_date
  end
end
