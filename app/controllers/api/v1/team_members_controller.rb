module Api
  module V1
    class TeamMembersController < ApplicationController
      before_action :set_team

      # POST /api/v1/teams/:team_id/members
      def create
        require_permission!("admin.teams.manage")
        member = @team.team_members.build(
          employee_id: params[:employee_id],
          role_title:  params[:role_title],
          joined_at:   params.fetch(:joined_at, Date.today),
          is_active:   true
        )
        if member.save
          render_created({ team_id: @team.id, employee_id: member.employee_id, role_title: member.role_title })
        else
          render_record_errors(member)
        end
      end

      # DELETE /api/v1/teams/:team_id/members/:employee_id
      def destroy
        require_permission!("admin.teams.manage")
        member = @team.team_members.active.find_by!(employee_id: params[:employee_id])
        member.update!(is_active: false, left_at: Date.today)
        render_no_content
      end

      private

      def set_team
        @team = Team.active.find(params[:team_id])
      end
    end
  end
end
