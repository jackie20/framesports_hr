class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string  :title,              limit: 255, null: false
      t.text    :description
      t.bigint  :creator_id,         null: false
      t.bigint  :assignee_id
      t.bigint  :team_id
      t.bigint  :status_lookup_id,   null: false
      t.bigint  :priority_lookup_id, null: false
      t.datetime :due_date,          precision: 7
      t.datetime :completed_at,      precision: 7
      t.bigint  :parent_task_id
      t.datetime :deleted_at,        precision: 7
      t.datetime :created_at,        precision: 7, null: false
      t.datetime :updated_at,        precision: 7, null: false
    end

    add_index :tasks, :creator_id,       name: "idx_tasks_creator"
    add_index :tasks, :assignee_id,      name: "idx_tasks_assignee"
    add_index :tasks, :team_id,          name: "idx_tasks_team"
    add_index :tasks, :status_lookup_id, name: "idx_tasks_status"
    add_index :tasks, :deleted_at,       name: "idx_tasks_deleted"

    create_table :task_comments do |t|
      t.bigint  :task_id,    null: false
      t.bigint  :author_id,  null: false
      t.text    :body,       null: false
      t.datetime :deleted_at, precision: 7
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :task_comments, :task_id,   name: "idx_tc_task"
    add_index :task_comments, :author_id, name: "idx_tc_author"
  end
end
