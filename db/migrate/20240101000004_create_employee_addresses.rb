class CreateEmployeeAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_addresses do |t|
      t.bigint  :employee_id,              null: false
      t.bigint  :address_type_lookup_id,   null: false
      t.string  :line1,                    limit: 255, null: false
      t.string  :line2,                    limit: 255
      t.string  :suburb,                   limit: 100
      t.string  :city,                     limit: 100, null: false
      t.string  :province_state,           limit: 100
      t.string  :postal_code,              limit: 20
      t.string  :country,                  limit: 100, null: false, default: "South Africa"
      t.boolean :is_primary,                           default: false
      t.date    :effective_from
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :employee_addresses, :employee_id, name: "idx_ea_employee"
  end
end
