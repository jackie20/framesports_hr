class TaskComment < ApplicationRecord
  include Discard::Model

  belongs_to :task
  belongs_to :author, class_name: "Employee"

  validates :body, presence: true
end
