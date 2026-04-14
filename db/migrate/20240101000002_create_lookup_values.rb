class CreateLookupValues < ActiveRecord::Migration[7.1]
  def change
    create_table :lookup_values do |t|
      t.bigint  :lookup_type_id, null: false
      t.string  :code,           limit: 100, null: false
      t.string  :value,          limit: 255, null: false
      t.string  :description,    limit: 500
      t.text    :meta_json
      t.boolean :is_active,      default: true, null: false
      t.integer :sort_order,     default: 0
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :lookup_values, :lookup_type_id, name: "idx_lv_type"
    add_index :lookup_values, [:lookup_type_id, :code], unique: true, name: "idx_lv_type_code_unique"
    add_foreign_key :lookup_values, :lookup_types, name: "fk_lv_lookup_type"
  end
end
