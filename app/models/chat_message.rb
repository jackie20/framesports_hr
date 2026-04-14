class ChatMessage < ApplicationRecord
  include Discard::Model

  belongs_to :chat_room
  belongs_to :sender,   class_name: "Employee", optional: true
  belongs_to :reply_to, class_name: "ChatMessage", optional: true
  has_many   :replies,  class_name: "ChatMessage", foreign_key: :reply_to_id

  validates :body, presence: true
  validates :message_type, inclusion: { in: %w[text file system] }

  scope :ordered, -> { kept.order(created_at: :asc) }
end
