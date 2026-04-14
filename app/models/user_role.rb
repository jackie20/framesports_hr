class UserRole < ApplicationRecord
  belongs_to :employee
  belongs_to :role
  belongs_to :assigned_by, class_name: "Employee", optional: true

  validates :employee_id, uniqueness: { scope: :role_id }

  scope :active, -> { where(is_active: true).where("expires_at IS NULL OR expires_at > ?", Time.current) }
end
