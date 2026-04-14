class RolePermission < ApplicationRecord
  belongs_to :role
  belongs_to :permission
  belongs_to :granted_by, class_name: "Employee", optional: true

  validates :role_id, uniqueness: { scope: :permission_id }
end
