class Employee < ApplicationRecord
  include Discard::Model
  include Encryptable

  has_secure_password

  # Associations — Lookup FKs
  belongs_to :title_lookup,           class_name: "LookupValue", optional: true,
             foreign_key: :title_lookup_id
  belongs_to :gender_lookup,          class_name: "LookupValue", optional: true,
             foreign_key: :gender_lookup_id
  belongs_to :marital_status_lookup,  class_name: "LookupValue", optional: true,
             foreign_key: :marital_status_lookup_id
  belongs_to :employment_type_lookup, class_name: "LookupValue", optional: true,
             foreign_key: :employment_type_lookup_id
  belongs_to :department_lookup,      class_name: "LookupValue", optional: true,
             foreign_key: :department_lookup_id
  belongs_to :created_by,             class_name: "Employee",     optional: true

  # Profile sub-records
  has_one  :employee_uniform,         dependent: :destroy
  has_many :employee_addresses,       dependent: :destroy
  has_many :employee_qualifications,  dependent: :destroy
  has_many :employee_documents,       dependent: :destroy
  has_many :employee_leaves,          dependent: :destroy
  has_many :leave_balances,           dependent: :destroy

  # RBAC
  has_many :user_roles,   dependent: :destroy
  has_many :roles,        through: :user_roles

  # Teams
  has_many :team_members, dependent: :destroy
  has_many :teams,        through: :team_members
  has_many :led_teams,    class_name: "Team", foreign_key: :team_lead_id

  # Reporting
  has_many :reporting_lines,
           class_name: "EmployeeReportingLine",
           foreign_key: :employee_id,
           dependent: :destroy
  has_many :managers,
           through: :reporting_lines,
           source: :reports_to

  # Tasks
  has_many :tasks,         foreign_key: :assignee_id, dependent: :nullify
  has_many :created_tasks, class_name: "Task",        foreign_key: :creator_id

  # Chat
  has_many :chat_participants, dependent: :destroy
  has_many :chat_rooms,        through: :chat_participants
  has_many :chat_messages,     class_name: "ChatMessage", foreign_key: :sender_id

  # Notifications
  has_many :notifications, dependent: :destroy

  # Documents / Files
  has_many :uploaded_documents, class_name: "EmployeeDocument", foreign_key: :uploaded_by_id
  has_many :shared_files,       foreign_key: :uploaded_by_id

  # Validations
  validates :first_name, :last_name, presence: true
  validates :work_email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :start_date, presence: true
  validates :employee_number, uniqueness: true, allow_blank: true

  # Callbacks
  before_create :generate_employee_number
  before_save   :downcase_email

  # Scopes
  scope :active,        -> { kept.where(is_active: true) }
  scope :onboarding,    -> { active.where(is_onboarding_complete: false) }
  scope :by_department, ->(dept_code) {
    active.joins(:department_lookup)
          .where(lookup_values: { code: dept_code })
  }

  def full_name
    [title_lookup&.value, first_name, last_name].compact.join(" ")
  end

  def display_name
    preferred_name.presence || "#{first_name} #{last_name}"
  end

  def all_permissions
    roles.active
         .includes(role_permissions: :permission)
         .flat_map(&:permissions)
         .map(&:code)
         .uniq
  end

  def has_permission?(code)
    all_permissions.include?(code.to_s)
  end

  def active?
    is_active && deleted_at.nil?
  end

  def pending_reset?
    password_reset_token.present? &&
      password_reset_sent_at.present? &&
      password_reset_sent_at > 1.hour.ago
  end

  private

  def generate_employee_number
    return if employee_number.present?
    last = Employee.unscoped.maximum(:id).to_i + 1
    self.employee_number = format("EMP-%05d", last)
  end

  def downcase_email
    self.work_email = work_email.downcase.strip if work_email.present?
  end
end
