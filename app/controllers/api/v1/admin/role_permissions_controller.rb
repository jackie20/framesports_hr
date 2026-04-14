module Api
  module V1
    module Admin
      class RolePermissionsController < ApplicationController
        before_action :set_role

        # POST /api/v1/admin/roles/:role_id/permissions
        def create
          require_permission!("admin.roles.assign_permissions")
          perm_codes = Array(params[:permission_codes] || params[:permission_code])

          perm_codes.each do |code|
            @role.assign_permission!(code, granted_by: current_employee)
          end

          render_success(RoleSerializer.new(@role.reload, include: [:permissions]).serializable_hash[:data])
        rescue ActiveRecord::RecordNotFound => e
          render json: error_response("Not Found", e.message, status: 404), status: :not_found
        end

        # DELETE /api/v1/admin/roles/:role_id/permissions/:perm_id
        def destroy
          require_permission!("admin.roles.assign_permissions")
          perm = Permission.find(params[:perm_id])
          @role.revoke_permission!(perm.code)
          render_no_content
        end

        private

        def set_role
          @role = Role.find(params[:role_id])
        end
      end
    end
  end
end
