class SharedFile < ApplicationRecord
  belongs_to :uploaded_by,          class_name: "Employee"
  belongs_to :file_category_lookup, class_name: "LookupValue", optional: true,
             foreign_key: :file_category_lookup_id
  belongs_to :team,                 optional: true
  belongs_to :parent_file,          class_name: "SharedFile", optional: true
  has_many   :versions,             class_name: "SharedFile", foreign_key: :parent_file_id
  has_many   :shared_file_employees, dependent: :destroy
  has_many   :recipients,            through: :shared_file_employees, source: :employee

  validates :title, :visibility, presence: true
  validates :visibility, inclusion: { in: %w[all team specific] }

  scope :active,   -> { where(is_active: true) }
  scope :visible_to, ->(employee) {
    active.where(
      "(visibility = 'all') OR " \
      "(visibility = 'team' AND team_id IN (?)) OR " \
      "(visibility = 'specific' AND id IN (SELECT shared_file_id FROM shared_file_employees WHERE employee_id = ?))",
      employee.team_ids.presence || [0],
      employee.id
    )
  }
end
