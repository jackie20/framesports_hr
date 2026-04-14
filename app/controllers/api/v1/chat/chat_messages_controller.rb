module Api
  module V1
    module Chat
      class ChatMessagesController < ApplicationController
        before_action :set_room

        # GET /api/v1/chat/rooms/:room_id/messages
        def index
          require_permission!("chat.participate")
          messages = paginate(@room.chat_messages.kept.includes(:sender).order(created_at: :asc))
          render_collection(messages.map { |m| ChatMessageSerializer.new(m).serializable_hash[:data] })
        end

        # POST /api/v1/chat/rooms/:room_id/messages
        def create
          require_permission!("chat.participate")
          message = @room.chat_messages.build(
            body:         params[:body],
            sender:       current_employee,
            message_type: params.fetch(:message_type, "text"),
            reply_to_id:  params[:reply_to_id]
          )
          if message.save
            ChatMessageBroadcastJob.perform_later(@room.id, message.id)
            render_created(ChatMessageSerializer.new(message).serializable_hash[:data])
          else
            render_record_errors(message)
          end
        end

        private

        def set_room
          @room = current_employee.chat_rooms.active.find(params[:room_id])
        end
      end
    end
  end
end
