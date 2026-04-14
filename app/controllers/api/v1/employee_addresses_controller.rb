module Api
  module V1
    class EmployeeAddressesController < ApplicationController
      before_action :set_employee
      before_action :set_address, only: [:show, :update, :destroy]

      def index
        require_permission!("employees.view_own", "employees.view_all")
        return render_forbidden unless can_access_employee?

        render_success(@employee.employee_addresses.map { |a| AddressSerializer.new(a).serializable_hash[:data] })
      end

      def show
        require_permission!("employees.view_own", "employees.view_all")
        render_success(AddressSerializer.new(@address).serializable_hash[:data])
      end

      def create
        require_permission!("employees.update_own", "employees.update_all")
        return render_forbidden unless can_access_employee?

        address = @employee.employee_addresses.build(address_params)
        if address.save
          render_created(AddressSerializer.new(address).serializable_hash[:data])
        else
          render_record_errors(address)
        end
      end

      def update
        require_permission!("employees.update_own", "employees.update_all")
        if @address.update(address_params)
          render_success(AddressSerializer.new(@address).serializable_hash[:data])
        else
          render_record_errors(@address)
        end
      end

      def destroy
        require_permission!("employees.update_own", "employees.update_all")
        @address.destroy
        render_no_content
      end

      private

      def set_employee
        @employee = Employee.active.find(params[:employee_id])
      end

      def set_address
        @address = @employee.employee_addresses.find(params[:id])
      end

      def address_params
        params.require(:employee_address).permit(
          :address_type_lookup_id, :line1, :line2, :suburb,
          :city, :province_state, :postal_code, :country,
          :is_primary, :effective_from
        )
      end

      def can_access_employee?
        current_employee.has_permission?("employees.update_all") ||
          @employee.id == current_employee.id
      end

      def render_forbidden
        render json: error_response("Forbidden", "Access denied", status: 403, code: "FORBIDDEN"),
               status: :forbidden
      end
    end
  end
end
