class Task < ApplicationRecord
  include Discard::Model

  belongs_to :creator,          class_name: "Employee"
  belongs_to :assignee,         class_name: "Employee", optional: true
  belongs_to :team,             optional: true
  belongs_to :status_lookup,    class_name: "LookupValue",
             foreign_key: :status_lookup_id
  belongs_to :priority_lookup,  class_name: "LookupValue",
             foreign_key: :priority_lookup_id
  belongs_to :parent_task,      class_name: "Task", optional: true
  has_many   :subtasks,         class_name: "Task", foreign_key: :parent_task_id, dependent: :destroy
  has_many   :task_comments,    dependent: :destroy

  validates :title, :creator_id, :status_lookup_id, :priority_lookup_id, presence: true

  scope :open,       -> { joins(:status_lookup).where(lookup_values: { code: "open" }) }
  scope :in_progress, -> { joins(:status_lookup).where(lookup_values: { code: "in_progress" }) }
  scope :overdue,    -> { kept.where("due_date < ? AND completed_at IS NULL", Time.current) }
  scope :for_team,   ->(team_id) { kept.where(team_id: team_id) }

  def completed?
    status_lookup&.code == "completed"
  end

  def overdue?
    due_date.present? && due_date < Time.current && completed_at.nil?
  end
end
