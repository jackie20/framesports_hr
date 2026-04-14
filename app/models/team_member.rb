class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :employee

  validates :joined_at, presence: true
  validates :employee_id, uniqueness: {
    scope: :team_id,
    conditions: -> { where(is_active: true) },
    message: "is already an active member of this team"
  }

  scope :active, -> { where(is_active: true) }
end
