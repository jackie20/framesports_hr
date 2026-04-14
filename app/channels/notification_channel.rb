class NotificationChannel < ApplicationCable::Channel
  def subscribed
    reject unless current_employee
    stream_from "notifications_#{current_employee.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
