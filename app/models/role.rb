class Role < ApplicationRecord
  belongs_to :created_by, class_name: "Employee", optional: true
  has_many :role_permissions, dependent: :destroy
  has_many :permissions,      through: :role_permissions
  has_many :user_roles,       dependent: :destroy
  has_many :employees,        through: :user_roles

  validates :name, :code, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :code, uniqueness: { case_sensitive: false }

  before_save :downcase_code

  scope :active,     -> { where(is_active: true) }
  scope :assignable, -> { active }

  def assign_permission!(permission_code, granted_by: nil)
    perm = Permission.find_by!(code: permission_code)
    role_permissions.find_or_create_by!(permission: perm) do |rp|
      rp.granted_by = granted_by
      rp.granted_at = Time.current
    end
  end

  def revoke_permission!(permission_code)
    perm = Permission.find_by!(code: permission_code)
    role_permissions.where(permission: perm).destroy_all
  end

  private

  def downcase_code
    self.code = code.downcase.strip if code.present?
  end
end
