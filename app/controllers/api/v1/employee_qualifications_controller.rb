module Api
  module V1
    class EmployeeQualificationsController < ApplicationController
      before_action :set_employee
      before_action :set_qualification, only: [:show, :update, :destroy]

      def index
        require_permission!("employees.view_own", "employees.view_all")
        render_success(@employee.employee_qualifications.map { |q| QualificationSerializer.new(q).serializable_hash[:data] })
      end

      def show
        render_success(QualificationSerializer.new(@qualification).serializable_hash[:data])
      end

      def create
        require_permission!("employees.update_own", "employees.update_all")
        qualification = @employee.employee_qualifications.build(qualification_params)
        if qualification.save
          render_created(QualificationSerializer.new(qualification).serializable_hash[:data])
        else
          render_record_errors(qualification)
        end
      end

      def update
        require_permission!("employees.update_own", "employees.update_all")
        if @qualification.update(qualification_params)
          render_success(QualificationSerializer.new(@qualification).serializable_hash[:data])
        else
          render_record_errors(@qualification)
        end
      end

      def destroy
        require_permission!("employees.update_all")
        @qualification.destroy
        render_no_content
      end

      private

      def set_employee
        @employee = Employee.active.find(params[:employee_id])
      end

      def set_qualification
        @qualification = @employee.employee_qualifications.find(params[:id])
      end

      def qualification_params
        params.require(:employee_qualification).permit(
          :qualification_type_lookup_id, :institution_name, :qualification_name,
          :field_of_study, :year_obtained, :expiry_date, :notes
        )
      end
    end
  end
end
