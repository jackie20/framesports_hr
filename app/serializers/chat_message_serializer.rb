class ChatMessageSerializer
  include JSONAPI::Serializer
  set_type :chat_message

  attributes :body, :message_type, :is_edited, :edited_at, :created_at

  attribute :sender do |obj|
    obj.sender ? { id: obj.sender.id, full_name: obj.sender.full_name } : nil
  end

  attribute :reply_to do |obj|
    obj.reply_to ? { id: obj.reply_to.id, body: obj.reply_to.body[0..100] } : nil
  end
end
