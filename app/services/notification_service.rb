class NotificationService < ApplicationService
  def self.send_to(employee:, type_code:, title:, body: nil, resource: nil, url: nil)
    type = LookupType.values_for(:notification_type).find_by(code: type_code)

    notif = employee.notifications.create!(
      notification_type_lookup_id: type&.id,
      title: title,
      body: body,
      action_url: url,
      notifiable: resource
    )

    ActionCable.server.broadcast("notifications_#{employee.id}", {
      id: notif.id,
      title: notif.title,
      body: notif.body,
      action_url: notif.action_url,
      created_at: notif.created_at
    })

    notif
  end
end
