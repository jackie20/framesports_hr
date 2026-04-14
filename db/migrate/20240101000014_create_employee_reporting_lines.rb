class CreateEmployeeReportingLines < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_reporting_lines do |t|
      t.bigint  :employee_id,                  null: false
      t.bigint  :reports_to_id,                null: false
      t.bigint  :relationship_type_lookup_id,  null: false
      t.date    :effective_from,               null: false
      t.date    :effective_to
      t.boolean :is_primary,                            default: true
      t.string  :notes,                        limit: 500
      t.bigint  :created_by_id
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :employee_reporting_lines, :employee_id,  name: "idx_erl_employee"
    add_index :employee_reporting_lines, :reports_to_id, name: "idx_erl_reports_to"
  end
end
