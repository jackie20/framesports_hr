class CreateChatTables < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_rooms do |t|
      t.string  :name,          limit: 200
      t.string  :room_type,     limit: 20, null: false
      t.bigint  :created_by_id
      t.bigint  :team_id
      t.boolean :is_active,                default: true
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :chat_rooms, :team_id, name: "idx_cr_team"

    create_table :chat_participants do |t|
      t.bigint  :chat_room_id, null: false
      t.bigint  :employee_id,  null: false
      t.string  :role,         limit: 20, default: "member"
      t.datetime :joined_at,   precision: 7
      t.datetime :last_read_at, precision: 7
    end

    add_index :chat_participants, [:chat_room_id, :employee_id],
              unique: true, name: "idx_cp_room_employee_unique"
    add_index :chat_participants, :employee_id, name: "idx_cp_employee"

    create_table :chat_messages do |t|
      t.bigint  :chat_room_id,  null: false
      t.bigint  :sender_id
      t.text    :body,          null: false
      t.string  :message_type,  limit: 20, default: "text"
      t.string  :file_path,     limit: 500
      t.bigint  :reply_to_id
      t.boolean :is_edited,                 default: false
      t.datetime :edited_at,    precision: 7
      t.datetime :deleted_at,   precision: 7
      t.datetime :created_at,   precision: 7, null: false
    end

    add_index :chat_messages, :chat_room_id, name: "idx_cm_room"
    add_index :chat_messages, :sender_id,    name: "idx_cm_sender"
    add_index :chat_messages, :deleted_at,   name: "idx_cm_deleted"
  end
end
