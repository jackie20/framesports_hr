class CreatePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.string  :code,        limit: 150, null: false
      t.string  :name,        limit: 255, null: false
      t.string  :category,    limit: 100, null: false
      t.string  :description, limit: 500
      t.boolean :is_system,              default: false, null: false
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :permissions, :code,     unique: true, name: "idx_permissions_code"
    add_index :permissions, :category,               name: "idx_permissions_category"
  end
end
