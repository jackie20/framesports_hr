class TaskCommentSerializer
  include JSONAPI::Serializer
  set_type :task_comment

  attributes :body, :created_at, :updated_at

  attribute :author do |obj|
    obj.author ? { id: obj.author.id, full_name: obj.author.full_name } : nil
  end
end
