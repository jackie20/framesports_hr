module Api
  module V1
    class EmployeeUniformsController < ApplicationController
      before_action :set_employee

      def show
        require_permission!("employees.view_own", "employees.view_all")
        uniform = @employee.employee_uniform || @employee.build_employee_uniform
        render_success(UniformSerializer.new(uniform).serializable_hash[:data])
      end

      def update
        require_permission!("employees.update_own", "employees.update_all")
        uniform = @employee.employee_uniform || @employee.build_employee_uniform

        if uniform.update_or_create(uniform_params)
          render_success(UniformSerializer.new(uniform).serializable_hash[:data])
        else
          render_record_errors(uniform)
        end
      end

      private

      def set_employee
        @employee = Employee.active.find(params[:employee_id])
      end

      def uniform_params
        params.require(:employee_uniform).permit(
          :shirt_size_lookup_id, :trouser_waist_cm, :trouser_length_cm,
          :jacket_size_lookup_id, :dress_size_lookup_id,
          :shoe_size, :shoe_size_system_lookup_id,
          :cap_size, :glove_size_lookup_id, :notes
        )
      end
    end
  end
end
