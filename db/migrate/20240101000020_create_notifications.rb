class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.bigint  :employee_id,                    null: false
      t.bigint  :notification_type_lookup_id
      t.string  :title,                          limit: 255, null: false
      t.string  :body,                           limit: 1000
      t.string  :action_url,                     limit: 500
      t.boolean :is_read,                                    default: false
      t.datetime :read_at,                       precision: 7
      t.string  :notifiable_type,                limit: 100
      t.bigint  :notifiable_id
      t.datetime :created_at, precision: 7, null: false
    end

    add_index :notifications, :employee_id,                  name: "idx_notif_employee"
    add_index :notifications, [:notifiable_type, :notifiable_id], name: "idx_notif_poly"
    add_index :notifications, :is_read,                      name: "idx_notif_read"
  end
end
