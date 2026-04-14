class ChatRoomSerializer
  include JSONAPI::Serializer
  set_type :chat_room

  attributes :name, :room_type, :is_active, :created_at

  attribute :participant_count do |obj|
    obj.chat_participants.count
  end

  attribute :team do |obj|
    obj.team ? { id: obj.team.id, name: obj.team.name } : nil
  end

  attribute :last_message do |obj|
    msg = obj.chat_messages.kept.order(created_at: :desc).first
    msg ? { id: msg.id, body: msg.body, sender: msg.sender&.full_name, sent_at: msg.created_at } : nil
  end
end
