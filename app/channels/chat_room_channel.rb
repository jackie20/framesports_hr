class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    room = ChatRoom.find(params[:room_id])
    reject unless current_employee&.chat_rooms&.include?(room)
    stream_from "chat_room_#{room.id}"
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    ChatMessageBroadcastJob.perform_later(
      params[:room_id].to_i,
      create_message(data)
    )
  end

  private

  def create_message(data)
    room = ChatRoom.find(params[:room_id])
    message = room.chat_messages.create!(
      sender:       current_employee,
      body:         data["body"],
      message_type: data.fetch("message_type", "text"),
      reply_to_id:  data["reply_to_id"]
    )
    message.id
  end
end
