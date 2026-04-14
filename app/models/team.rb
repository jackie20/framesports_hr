class Team < ApplicationRecord
  belongs_to :parent_team, class_name: "Team", optional: true
  has_many   :sub_teams,   class_name: "Team", foreign_key: :parent_team_id, dependent: :nullify
  belongs_to :team_lead,   class_name: "Employee", optional: true
  belongs_to :created_by,  class_name: "Employee", optional: true
  has_many   :team_members, dependent: :destroy
  has_many   :employees,   through: :team_members
  has_many   :chat_rooms,  dependent: :nullify
  has_many   :tasks,       dependent: :nullify
  has_many   :shared_files, dependent: :nullify

  validates :name, :code, presence: true
  validates :code, uniqueness: { case_sensitive: false }

  before_save :downcase_code

  scope :active, -> { where(is_active: true) }
  scope :roots,  -> { where(parent_team_id: nil) }

  def self.org_tree
    roots.active.includes(:sub_teams, :team_lead, team_members: :employee)
  end

  def depth
    parent_team ? parent_team.depth + 1 : 0
  end

  def member_count
    team_members.where(is_active: true).count
  end

  private

  def downcase_code
    self.code = code.downcase.strip if code.present?
  end
end
