class CreateEmployeeLeaves < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_leaves do |t|
      t.bigint  :employee_id,          null: false
      t.bigint  :leave_type_lookup_id, null: false
      t.bigint  :status_lookup_id,     null: false
      t.date    :start_date,           null: false
      t.date    :end_date,             null: false
      t.decimal :days_requested,       precision: 6, scale: 2, null: false
      t.string  :reason,               limit: 1000
      t.bigint  :reviewer_id
      t.datetime :reviewed_at,         precision: 7
      t.string  :review_comment,       limit: 1000
      t.string  :supporting_doc_path,  limit: 500
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :employee_leaves, :employee_id,          name: "idx_el_employee"
    add_index :employee_leaves, :status_lookup_id,     name: "idx_el_status"
    add_index :employee_leaves, [:employee_id, :start_date, :end_date], name: "idx_el_dates"
  end
end
