class CreateSharedFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_files do |t|
      t.string  :title,                    limit: 255, null: false
      t.string  :description,              limit: 1000
      t.bigint  :file_category_lookup_id
      t.string  :file_path,                limit: 500
      t.string  :file_name,                limit: 255
      t.string  :content_type,             limit: 100
      t.bigint  :file_size
      t.bigint  :uploaded_by_id,           null: false
      t.string  :visibility,               limit: 20, null: false, default: "all"
      t.bigint  :team_id
      t.boolean :is_active,                            default: true
      t.integer :version,                              default: 1
      t.bigint  :parent_file_id
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :shared_files, :uploaded_by_id, name: "idx_sf_uploader"
    add_index :shared_files, :team_id,        name: "idx_sf_team"

    create_table :shared_file_employees do |t|
      t.bigint  :shared_file_id, null: false
      t.bigint  :employee_id,    null: false
      t.datetime :shared_at,     precision: 7
    end

    add_index :shared_file_employees, [:shared_file_id, :employee_id],
              unique: true, name: "idx_sfe_unique"
  end
end
