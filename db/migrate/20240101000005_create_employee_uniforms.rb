class CreateEmployeeUniforms < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_uniforms do |t|
      t.bigint   :employee_id,                null: false
      t.bigint   :shirt_size_lookup_id
      t.decimal  :trouser_waist_cm,           precision: 5, scale: 1
      t.decimal  :trouser_length_cm,          precision: 5, scale: 1
      t.bigint   :jacket_size_lookup_id
      t.bigint   :dress_size_lookup_id
      t.decimal  :shoe_size,                  precision: 4, scale: 1
      t.bigint   :shoe_size_system_lookup_id
      t.string   :cap_size,                   limit: 20
      t.bigint   :glove_size_lookup_id
      t.string   :notes,                      limit: 500
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :employee_uniforms, :employee_id, unique: true, name: "idx_eu_employee_unique"
  end
end
