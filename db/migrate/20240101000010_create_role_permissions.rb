class CreateRolePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :role_permissions do |t|
      t.bigint  :role_id,       null: false
      t.bigint  :permission_id, null: false
      t.bigint  :granted_by_id
      t.datetime :granted_at,  precision: 7
    end

    add_index :role_permissions, [:role_id, :permission_id], unique: true, name: "idx_rp_role_permission_unique"
    add_index :role_permissions, :role_id,                   name: "idx_rp_role"
    add_index :role_permissions, :permission_id,             name: "idx_rp_permission"
  end
end
