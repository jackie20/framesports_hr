module Api
  module V1
    module Admin
      class RolesController < ApplicationController
        before_action :set_role, only: [:show, :update, :destroy]

        # GET /api/v1/admin/roles
        def index
          require_permission!("admin.roles.view")
          roles = Role.active.includes(:permissions).order(:name)
          render_success(roles.map { |r| RoleSerializer.new(r).serializable_hash[:data] })
        end

        # GET /api/v1/admin/roles/:id
        def show
          require_permission!("admin.roles.view")
          render_success(RoleSerializer.new(@role, include: [:permissions]).serializable_hash[:data])
        end

        # POST /api/v1/admin/roles
        def create
          require_permission!("admin.roles.create")
          role = Role.new(role_params.merge(created_by: current_employee))
          if role.save
            render_created(RoleSerializer.new(role).serializable_hash[:data])
          else
            render_record_errors(role)
          end
        end

        # PUT /api/v1/admin/roles/:id
        def update
          require_permission!("admin.roles.update")
          if @role.is_system && !current_employee.has_permission?("admin.system")
            return render json: error_response("Forbidden", "System roles cannot be modified", status: 403), status: :forbidden
          end
          if @role.update(role_params)
            render_success(RoleSerializer.new(@role).serializable_hash[:data])
          else
            render_record_errors(@role)
          end
        end

        # DELETE /api/v1/admin/roles/:id
        def destroy
          require_permission!("admin.roles.delete")
          if @role.is_system
            return render json: error_response("Forbidden", "System roles cannot be deleted", status: 403), status: :forbidden
          end
          @role.update!(is_active: false)
          render_no_content
        end

        private

        def set_role
          @role = Role.find(params[:id])
        end

        def role_params
          params.require(:role).permit(:name, :code, :description, :can_assign_permissions)
        end
      end
    end
  end
end
