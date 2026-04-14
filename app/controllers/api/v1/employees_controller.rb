module Api
  module V1
    class EmployeesController < ApplicationController
      before_action :set_employee, only: [:show, :update, :destroy]

      # GET /api/v1/employees
      def index
        require_permission!("employees.view_all")
        employees = EmployeeSearchQuery.new(Employee.active.includes(:department_lookup, :employment_type_lookup, :roles), params).call
        employees = paginate(employees)
        render_collection(EmployeeSerializer.new(employees).serializable_hash[:data])
      end

      # POST /api/v1/employees
      def create
        require_permission!("employees.create")
        result = EmployeeCreatorService.call(params: employee_params, created_by: current_employee)

        if result.success?
          render_created(EmployeeSerializer.new(result.data).serializable_hash[:data])
        else
          render json: error_response("Unprocessable Entity", result.error, status: 422), status: :unprocessable_entity
        end
      end

      # GET /api/v1/employees/:id
      def show
        require_permission!("employees.view_all", "employees.view_own")
        return render_forbidden_own unless can_view_employee?

        render_success(
          EmployeeSerializer.new(@employee, include: [:addresses, :qualifications, :uniform, :roles]).serializable_hash[:data],
          meta: { timestamp: Time.current.iso8601 }
        )
      end

      # PUT /api/v1/employees/:id
      def update
        require_permission!("employees.update_all", "employees.update_own")
        return render_forbidden_own unless can_update_employee?

        if @employee.update(employee_params)
          render_success(EmployeeSerializer.new(@employee).serializable_hash[:data])
        else
          render_record_errors(@employee)
        end
      end

      # DELETE /api/v1/employees/:id
      def destroy
        require_permission!("employees.delete")
        @employee.discard
        @employee.update_column(:is_active, false)
        render_no_content
      end

      private

      def set_employee
        @employee = Employee.active.find(params[:id])
      end

      def employee_params
        params.require(:employee).permit(
          :first_name, :middle_name, :last_name, :preferred_name,
          :work_email, :personal_email, :phone_mobile, :phone_work,
          :date_of_birth, :nationality, :job_title,
          :start_date, :end_date, :is_active,
          :title_lookup_id, :gender_lookup_id, :marital_status_lookup_id,
          :employment_type_lookup_id, :department_lookup_id,
          :password, :password_confirmation,
          :national_id_number, :passport_number, :tax_number
        )
      end

      def can_view_employee?
        current_employee.has_permission?("employees.view_all") ||
          @employee.id == current_employee.id
      end

      def can_update_employee?
        current_employee.has_permission?("employees.update_all") ||
          (@employee.id == current_employee.id && current_employee.has_permission?("employees.update_own"))
      end

      def render_forbidden_own
        render json: error_response("Forbidden", "You can only access your own profile", status: 403, code: "FORBIDDEN"),
               status: :forbidden
      end
    end
  end
end
