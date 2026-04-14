class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string  :name,                   limit: 200, null: false
      t.string  :code,                   limit: 100, null: false
      t.string  :description,            limit: 500
      t.boolean :is_system,                          default: false, null: false
      t.boolean :can_assign_permissions,             default: false, null: false
      t.bigint  :created_by_id
      t.boolean :is_active,                          default: true,  null: false
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :roles, :name, unique: true, name: "idx_roles_name"
    add_index :roles, :code, unique: true, name: "idx_roles_code"
  end
end
