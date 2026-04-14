module Api
  module V1
    module Admin
      class UserRolesController < ApplicationController
        before_action :set_employee

        # POST /api/v1/admin/employees/:employee_id/roles
        def create
          require_permission!("admin.users.assign_roles")
          role = Role.active.find(params[:role_id])
          user_role = UserRole.find_or_create_by!(employee: @employee, role: role) do |ur|
            ur.assigned_by = current_employee
            ur.assigned_at = Time.current
            ur.is_active   = true
          end
          render_created({ employee_id: @employee.id, role: role.code, assigned_at: user_role.assigned_at })
        end

        # DELETE /api/v1/admin/employees/:employee_id/roles/:role_id
        def destroy
          require_permission!("admin.users.assign_roles")
          user_role = UserRole.find_by!(employee: @employee, role_id: params[:role_id], is_active: true)
          user_role.update!(is_active: false)
          render_no_content
        end

        private

        def set_employee
          @employee = Employee.active.find(params[:employee_id])
        end
      end
    end
  end
end
