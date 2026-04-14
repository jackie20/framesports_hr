class ChatRoom < ApplicationRecord
  belongs_to :created_by, class_name: "Employee", optional: true
  belongs_to :team, optional: true
  has_many   :chat_participants, dependent: :destroy
  has_many   :participants,      through: :chat_participants, source: :employee
  has_many   :chat_messages,     dependent: :destroy

  validates :room_type, presence: true,
            inclusion: { in: %w[direct group channel] }

  scope :active, -> { where(is_active: true) }

  def direct?
    room_type == "direct"
  end

  def group?
    room_type == "group"
  end
end
