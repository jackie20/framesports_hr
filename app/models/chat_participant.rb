class ChatParticipant < ApplicationRecord
  belongs_to :chat_room
  belongs_to :employee

  validates :chat_room_id, uniqueness: { scope: :employee_id }
  validates :role, inclusion: { in: %w[member admin] }
end
