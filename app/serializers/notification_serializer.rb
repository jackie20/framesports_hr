class NotificationSerializer
  include JSONAPI::Serializer
  set_type :notification

  attributes :title, :body, :action_url, :is_read, :read_at, :created_at

  attribute :notification_type do |obj|
    obj.notification_type_lookup ? { id: obj.notification_type_lookup.id, code: obj.notification_type_lookup.code, value: obj.notification_type_lookup.value } : nil
  end
end
