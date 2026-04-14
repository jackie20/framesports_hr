class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string   :employee_number,          limit: 50,  null: false
      t.bigint   :title_lookup_id
      t.string   :first_name,               limit: 100, null: false
      t.string   :middle_name,              limit: 100
      t.string   :last_name,                limit: 100, null: false
      t.string   :preferred_name,           limit: 100
      t.bigint   :gender_lookup_id
      t.date     :date_of_birth
      t.string   :national_id_number,       limit: 500  # stored encrypted
      t.string   :passport_number,          limit: 500
      t.string   :tax_number,               limit: 500
      t.bigint   :marital_status_lookup_id
      t.string   :nationality,              limit: 100
      t.string   :personal_email,           limit: 255
      t.string   :work_email,               limit: 255, null: false
      t.string   :phone_mobile,             limit: 30
      t.string   :phone_work,               limit: 30
      t.bigint   :employment_type_lookup_id
      t.bigint   :department_lookup_id
      t.string   :job_title,                limit: 200
      t.date     :start_date,                            null: false
      t.date     :end_date
      t.boolean  :is_active,                            default: true,  null: false
      t.boolean  :is_onboarding_complete,               default: false, null: false
      t.datetime :onboarding_completed_at,  precision: 7
      t.string   :password_digest,          limit: 255, null: false
      t.datetime :last_login_at,            precision: 7
      t.string   :password_reset_token,     limit: 255
      t.datetime :password_reset_sent_at,   precision: 7
      t.bigint   :created_by_id
      t.datetime :deleted_at,               precision: 7
      t.datetime :created_at,               precision: 7, null: false
      t.datetime :updated_at,               precision: 7, null: false
    end

    add_index :employees, :employee_number, unique: true, name: "idx_emp_number_unique"
    add_index :employees, :work_email,      unique: true, name: "idx_emp_email_unique"
    add_index :employees, :is_active,                    name: "idx_emp_active"
    add_index :employees, :deleted_at,                   name: "idx_emp_deleted"
    add_index :employees, :department_lookup_id,         name: "idx_emp_dept"
  end
end
