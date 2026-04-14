class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string  :name,           limit: 200, null: false
      t.string  :code,           limit: 100, null: false
      t.string  :description,    limit: 1000
      t.bigint  :parent_team_id
      t.bigint  :team_lead_id
      t.boolean :is_active,                  default: true, null: false
      t.bigint  :created_by_id
      t.datetime :created_at, precision: 7, null: false
      t.datetime :updated_at, precision: 7, null: false
    end

    add_index :teams, :code,          unique: true, name: "idx_teams_code"
    add_index :teams, :parent_team_id,               name: "idx_teams_parent"
    add_index :teams, :team_lead_id,                 name: "idx_teams_lead"
  end
end
