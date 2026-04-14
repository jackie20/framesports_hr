class CreateTeamMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :team_members do |t|
      t.bigint  :team_id,     null: false
      t.bigint  :employee_id, null: false
      t.string  :role_title,  limit: 200
      t.date    :joined_at,   null: false
      t.date    :left_at
      t.boolean :is_active,              default: true, null: false
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :team_members, [:team_id, :employee_id], name: "idx_tm_team_employee"
    add_index :team_members, :team_id,                 name: "idx_tm_team"
    add_index :team_members, :employee_id,             name: "idx_tm_employee"
  end
end
