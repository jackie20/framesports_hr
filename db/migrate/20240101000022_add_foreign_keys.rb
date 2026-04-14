class AddForeignKeys < ActiveRecord::Migration[7.1]
  def change
    # Lookup types
    add_foreign_key :lookup_types, :employees, column: :created_by_id, name: "fk_lt_created_by"

    # Employees
    add_foreign_key :employees, :lookup_values, column: :title_lookup_id,           name: "fk_emp_title"
    add_foreign_key :employees, :lookup_values, column: :gender_lookup_id,          name: "fk_emp_gender"
    add_foreign_key :employees, :lookup_values, column: :marital_status_lookup_id,  name: "fk_emp_marital"
    add_foreign_key :employees, :lookup_values, column: :employment_type_lookup_id, name: "fk_emp_employment"
    add_foreign_key :employees, :lookup_values, column: :department_lookup_id,      name: "fk_emp_dept"
    add_foreign_key :employees, :employees,     column: :created_by_id,             name: "fk_emp_created_by"

    # Employee addresses
    add_foreign_key :employee_addresses, :employees,    column: :employee_id,            name: "fk_ea_employee"
    add_foreign_key :employee_addresses, :lookup_values, column: :address_type_lookup_id, name: "fk_ea_type"

    # Employee uniforms
    add_foreign_key :employee_uniforms, :employees, column: :employee_id, name: "fk_eu_employee"

    # Employee qualifications
    add_foreign_key :employee_qualifications, :employees, column: :employee_id,    name: "fk_eq_employee"
    add_foreign_key :employee_qualifications, :employees, column: :verified_by_id, name: "fk_eq_verified_by"

    # Employee documents
    add_foreign_key :employee_documents, :employees,    column: :employee_id,             name: "fk_edoc_employee"
    add_foreign_key :employee_documents, :employees,    column: :uploaded_by_id,          name: "fk_edoc_uploader"
    add_foreign_key :employee_documents, :employees,    column: :verified_by_id,          name: "fk_edoc_verified_by"
    add_foreign_key :employee_documents, :lookup_values, column: :document_type_lookup_id, name: "fk_edoc_type"

    # Roles & Permissions
    add_foreign_key :roles,            :employees,  column: :created_by_id, name: "fk_roles_created_by"
    add_foreign_key :role_permissions, :roles,                               name: "fk_rp_role"
    add_foreign_key :role_permissions, :permissions,                         name: "fk_rp_permission"
    add_foreign_key :role_permissions, :employees,  column: :granted_by_id, name: "fk_rp_granted_by"
    add_foreign_key :user_roles,       :employees,                           name: "fk_ur_employee"
    add_foreign_key :user_roles,       :roles,                               name: "fk_ur_role"
    add_foreign_key :user_roles,       :employees,  column: :assigned_by_id, name: "fk_ur_assigned_by"

    # Teams
    add_foreign_key :teams,        :teams,     column: :parent_team_id, name: "fk_teams_parent"
    add_foreign_key :teams,        :employees, column: :team_lead_id,   name: "fk_teams_lead"
    add_foreign_key :teams,        :employees, column: :created_by_id,  name: "fk_teams_created_by"
    add_foreign_key :team_members, :teams,                               name: "fk_tm_team"
    add_foreign_key :team_members, :employees,                           name: "fk_tm_employee"

    # Reporting lines
    add_foreign_key :employee_reporting_lines, :employees,    column: :employee_id,   name: "fk_erl_employee"
    add_foreign_key :employee_reporting_lines, :employees,    column: :reports_to_id, name: "fk_erl_reports_to"
    add_foreign_key :employee_reporting_lines, :lookup_values, column: :relationship_type_lookup_id, name: "fk_erl_type"
    add_foreign_key :employee_reporting_lines, :employees,    column: :created_by_id, name: "fk_erl_created_by"

    # Leave
    add_foreign_key :leave_balances,  :employees,    column: :employee_id,          name: "fk_lb_employee"
    add_foreign_key :leave_balances,  :lookup_values, column: :leave_type_lookup_id, name: "fk_lb_leave_type"
    add_foreign_key :employee_leaves, :employees,    column: :employee_id,          name: "fk_el_employee"
    add_foreign_key :employee_leaves, :employees,    column: :reviewer_id,          name: "fk_el_reviewer"
    add_foreign_key :employee_leaves, :lookup_values, column: :leave_type_lookup_id, name: "fk_el_leave_type"
    add_foreign_key :employee_leaves, :lookup_values, column: :status_lookup_id,    name: "fk_el_status"

    # Shared files
    add_foreign_key :shared_files, :employees, column: :uploaded_by_id, name: "fk_sf_uploader"
    add_foreign_key :shared_files, :teams,     column: :team_id,        name: "fk_sf_team"
    add_foreign_key :shared_files, :shared_files, column: :parent_file_id, name: "fk_sf_parent"
    add_foreign_key :shared_file_employees, :shared_files, name: "fk_sfe_file"
    add_foreign_key :shared_file_employees, :employees,    name: "fk_sfe_employee"

    # Chat
    add_foreign_key :chat_rooms,    :employees, column: :created_by_id, name: "fk_cr_created_by"
    add_foreign_key :chat_rooms,    :teams,     column: :team_id,       name: "fk_cr_team"
    add_foreign_key :chat_participants, :chat_rooms,                     name: "fk_cp_room"
    add_foreign_key :chat_participants, :employees,                      name: "fk_cp_employee"
    add_foreign_key :chat_messages, :chat_rooms,                         name: "fk_cm_room"
    add_foreign_key :chat_messages, :employees, column: :sender_id,     name: "fk_cm_sender"
    add_foreign_key :chat_messages, :chat_messages, column: :reply_to_id, name: "fk_cm_reply_to"

    # Tasks
    add_foreign_key :tasks,         :employees, column: :creator_id,  name: "fk_tasks_creator"
    add_foreign_key :tasks,         :employees, column: :assignee_id, name: "fk_tasks_assignee"
    add_foreign_key :tasks,         :teams,     column: :team_id,     name: "fk_tasks_team"
    add_foreign_key :tasks,         :tasks,     column: :parent_task_id, name: "fk_tasks_parent"
    add_foreign_key :task_comments, :tasks,                             name: "fk_tc_task"
    add_foreign_key :task_comments, :employees, column: :author_id,   name: "fk_tc_author"

    # Notifications
    add_foreign_key :notifications, :employees, column: :employee_id, name: "fk_notif_employee"
  end
end
