class Notification < ApplicationRecord
  belongs_to :employee
  belongs_to :notification_type_lookup, class_name: "LookupValue", optional: true,
             foreign_key: :notification_type_lookup_id

  belongs_to :notifiable, polymorphic: true, optional: true

  validates :title, presence: true

  scope :unread,   -> { where(is_read: false) }
  scope :recent,   -> { order(created_at: :desc) }
  scope :for_type, ->(code) { joins(:notification_type_lookup).where(lookup_values: { code: code }) }

  def mark_read!
    update!(is_read: true, read_at: Time.current) unless is_read?
  end
end
