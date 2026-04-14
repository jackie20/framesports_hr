class CreateEmployeeQualifications < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_qualifications do |t|
      t.bigint  :employee_id,                     null: false
      t.bigint  :qualification_type_lookup_id,    null: false
      t.string  :institution_name,               limit: 255, null: false
      t.string  :qualification_name,             limit: 255, null: false
      t.string  :field_of_study,                 limit: 255
      t.integer :year_obtained
      t.date    :expiry_date
      t.boolean :is_verified,                              default: false
      t.bigint  :verified_by_id
      t.datetime :verified_at,                   precision: 7
      t.string  :notes,                          limit: 500
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :employee_qualifications, :employee_id, name: "idx_eq_employee"
  end
end
