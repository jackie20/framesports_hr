module Api
  module V1
    class NotificationsController < ApplicationController
      # GET /api/v1/notifications
      def index
        notifications = paginate(
          current_employee.notifications
                          .includes(:notification_type_lookup)
                          .recent
        )
        render_collection(notifications.map { |n| NotificationSerializer.new(n).serializable_hash[:data] })
      end

      # PUT /api/v1/notifications/:id/read
      def read
        notification = current_employee.notifications.find(params[:id])
        notification.mark_read!
        render_success(NotificationSerializer.new(notification).serializable_hash[:data])
      end

      # PUT /api/v1/notifications/read_all
      def read_all
        current_employee.notifications.unread.update_all(is_read: true, read_at: Time.current)
        render_success({ message: "All notifications marked as read." })
      end
    end
  end
end
