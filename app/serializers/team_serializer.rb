class TeamSerializer
  include JSONAPI::Serializer
  set_type :team

  attributes :name, :code, :description, :is_active

  attribute :depth do |obj|
    obj.depth
  end

  attribute :member_count do |obj|
    obj.member_count
  end

  attribute :team_lead do |obj|
    obj.team_lead ? { id: obj.team_lead.id, full_name: obj.team_lead.full_name, employee_number: obj.team_lead.employee_number } : nil
  end

  attribute :parent_team do |obj|
    obj.parent_team ? { id: obj.parent_team.id, name: obj.parent_team.name, code: obj.parent_team.code } : nil
  end

  has_many :sub_teams, serializer: TeamSerializer
end
