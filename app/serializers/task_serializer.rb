class TaskSerializer
  include JSONAPI::Serializer
  set_type :task

  attributes :title, :description, :due_date, :completed_at, :created_at

  attribute :status do |obj|
    obj.status_lookup ? { id: obj.status_lookup.id, code: obj.status_lookup.code, value: obj.status_lookup.value } : nil
  end

  attribute :priority do |obj|
    obj.priority_lookup ? { id: obj.priority_lookup.id, code: obj.priority_lookup.code, value: obj.priority_lookup.value } : nil
  end

  attribute :creator do |obj|
    obj.creator ? { id: obj.creator.id, full_name: obj.creator.full_name } : nil
  end

  attribute :assignee do |obj|
    obj.assignee ? { id: obj.assignee.id, full_name: obj.assignee.full_name } : nil
  end

  attribute :is_overdue do |obj|
    obj.overdue?
  end

  has_many :task_comments, serializer: TaskCommentSerializer
end
