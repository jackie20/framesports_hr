class ChatMessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(room_id, message_id)
    message = ChatMessage.includes(:sender).find(message_id)
    payload = ChatMessageSerializer.new(message).serializable_hash[:data]

    ActionCable.server.broadcast("chat_room_#{room_id}", payload)

    # Notify room participants who are not the sender
    room = ChatRoom.find(room_id)
    room.participants.where.not(id: message.sender_id).each do |participant|
      NotificationService.send_to(
        employee:  participant,
        type_code: "chat",
        title:     "New message in #{room.name || 'Direct Message'}",
        body:      message.body.truncate(100),
        resource:  message,
        url:       "/chat/rooms/#{room_id}"
      )
    end
  end
end
