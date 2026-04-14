class CreateEmployeeDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :employee_documents do |t|
      t.bigint  :employee_id,                null: false
      t.bigint  :document_type_lookup_id,    null: false
      t.string  :title,                      limit: 255, null: false
      t.string  :description,                limit: 1000
      t.string  :file_path,                  limit: 500
      t.string  :file_name,                  limit: 255
      t.string  :content_type,               limit: 100
      t.bigint  :file_size
      t.date    :issue_date
      t.date    :expiry_date
      t.boolean :is_verified,                             default: false
      t.bigint  :verified_by_id
      t.datetime :verified_at,               precision: 7
      t.boolean :is_confidential,                        default: false
      t.bigint  :uploaded_by_id,             null: false
      t.datetime :deleted_at,                precision: 7
      t.datetime :created_at,                precision: 7, null: false
      t.datetime :updated_at,                precision: 7, null: false
    end

    add_index :employee_documents, :employee_id, name: "idx_edoc_employee"
    add_index :employee_documents, :deleted_at,  name: "idx_edoc_deleted"
  end
end
