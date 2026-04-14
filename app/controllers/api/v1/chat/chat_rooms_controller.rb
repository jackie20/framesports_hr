module Api
  module V1
    module Chat
      class ChatRoomsController < ApplicationController
        before_action :set_room, only: [:show, :update, :destroy]

        # GET /api/v1/chat/rooms
        def index
          require_permission!("chat.participate")
          rooms = current_employee.chat_rooms.active.order(updated_at: :desc)
          render_success(rooms.map { |r| ChatRoomSerializer.new(r).serializable_hash[:data] })
        end

        # GET /api/v1/chat/rooms/:id
        def show
          require_permission!("chat.participate")
          render_success(ChatRoomSerializer.new(@room).serializable_hash[:data])
        end

        # POST /api/v1/chat/rooms
        def create
          require_permission!("chat.create_room")
          room = ChatRoom.new(room_params.merge(created_by: current_employee))

          ActiveRecord::Base.transaction do
            room.save!
            room.chat_participants.create!(employee: current_employee, role: "admin", joined_at: Time.current)
            Array(params[:participant_ids]).each do |eid|
              room.chat_participants.create!(employee_id: eid, role: "member", joined_at: Time.current)
            end
          end

          render_created(ChatRoomSerializer.new(room).serializable_hash[:data])
        rescue ActiveRecord::RecordInvalid => e
          render_record_errors(e.record)
        end

        # DELETE /api/v1/chat/rooms/:id
        def destroy
          require_permission!("chat.manage")
          @room.update!(is_active: false)
          render_no_content
        end

        private

        def set_room
          @room = current_employee.chat_rooms.active.find(params[:id])
        end

        def room_params
          params.require(:chat_room).permit(:name, :room_type, :team_id)
        end
      end
    end
  end
end
