class CreateUserRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_roles do |t|
      t.bigint  :employee_id,  null: false
      t.bigint  :role_id,      null: false
      t.bigint  :assigned_by_id
      t.datetime :assigned_at, precision: 7
      t.datetime :expires_at,  precision: 7
      t.boolean :is_active,                default: true, null: false
    end

    add_index :user_roles, [:employee_id, :role_id], unique: true, name: "idx_ur_employee_role_unique"
    add_index :user_roles, :employee_id,                           name: "idx_ur_employee"
    add_index :user_roles, :role_id,                               name: "idx_ur_role"
  end
end
