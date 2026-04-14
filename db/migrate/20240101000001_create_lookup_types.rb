class CreateLookupTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :lookup_types do |t|
      t.string  :code,        limit: 100, null: false
      t.string  :name,        limit: 255, null: false
      t.string  :description, limit: 500
      t.boolean :is_system,              default: false, null: false
      t.boolean :is_active,              default: true,  null: false
      t.integer :sort_order,             default: 0
      t.bigint  :created_by_id
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :lookup_types, :code,      unique: true, name: "idx_lookup_types_code"
    add_index :lookup_types, :is_active,               name: "idx_lookup_types_active"
  end
end
