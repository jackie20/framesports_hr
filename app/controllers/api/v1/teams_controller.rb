module Api
  module V1
    class TeamsController < ApplicationController
      before_action :set_team, only: [:show, :update, :destroy]

      # GET /api/v1/teams/org_chart
      def org_chart
        teams = Team.org_tree
        render_success(teams.map { |t| TeamSerializer.new(t, params: { include_subtrees: true }).serializable_hash[:data] })
      end

      # GET /api/v1/teams
      def index
        teams = paginate(Team.active.includes(:team_lead, :parent_team).order(:name))
        render_collection(teams.map { |t| TeamSerializer.new(t).serializable_hash[:data] })
      end

      # GET /api/v1/teams/:id
      def show
        render_success(TeamSerializer.new(@team, include: [:team_members]).serializable_hash[:data])
      end

      # POST /api/v1/teams
      def create
        require_permission!("admin.teams.manage")
        team = Team.new(team_params.merge(created_by: current_employee))
        if team.save
          render_created(TeamSerializer.new(team).serializable_hash[:data])
        else
          render_record_errors(team)
        end
      end

      # PUT /api/v1/teams/:id
      def update
        require_permission!("admin.teams.manage")
        if @team.update(team_params)
          render_success(TeamSerializer.new(@team).serializable_hash[:data])
        else
          render_record_errors(@team)
        end
      end

      # DELETE /api/v1/teams/:id
      def destroy
        require_permission!("admin.teams.manage")
        @team.update!(is_active: false)
        render_no_content
      end

      private

      def set_team
        @team = Team.find(params[:id])
      end

      def team_params
        params.require(:team).permit(:name, :code, :description, :parent_team_id, :team_lead_id)
      end
    end
  end
end
