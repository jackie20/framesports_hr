class CreateLeaveBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :leave_balances do |t|
      t.bigint  :employee_id,           null: false
      t.bigint  :leave_type_lookup_id,  null: false
      t.integer :year,                  null: false
      t.decimal :total_days,            precision: 6, scale: 2, null: false
      t.decimal :used_days,             precision: 6, scale: 2, default: 0
      t.decimal :pending_days,          precision: 6, scale: 2, default: 0
      t.decimal :carried_over_days,     precision: 6, scale: 2, default: 0
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :leave_balances, [:employee_id, :leave_type_lookup_id, :year],
              unique: true, name: "idx_lb_employee_type_year_unique"
    add_index :leave_balances, :employee_id, name: "idx_lb_employee"
  end
end
