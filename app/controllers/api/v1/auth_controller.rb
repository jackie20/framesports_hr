module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_employee!, only: [:login, :forgot_password, :reset_password]

      # POST /api/v1/auth/login
      def login
        employee = Employee.active.find_by(work_email: params[:email]&.downcase&.strip)

        unless employee&.authenticate(params[:password])
          return render json: error_response(
            "Unauthorized",
            "Invalid email or password",
            status: 401,
            code: "INVALID_CREDENTIALS"
          ), status: :unauthorized
        end

        employee.update_column(:last_login_at, Time.current)
        token = JwtService.encode(sub: employee.id)

        render_success(login_payload(employee, token), status: :ok)
      end

      # POST /api/v1/auth/logout
      def logout
        token = extract_token
        JwtService.revoke!(token) if token
        render_no_content
      end

      # POST /api/v1/auth/refresh
      def refresh
        new_token = JwtService.encode(sub: current_employee.id)
        JwtService.revoke!(extract_token)
        render_success({ token: new_token, expires_at: 24.hours.from_now.iso8601 })
      end

      # POST /api/v1/auth/forgot_password
      def forgot_password
        employee = Employee.active.find_by(work_email: params[:email]&.downcase&.strip)

        if employee
          token = SecureRandom.urlsafe_base64(32)
          employee.update!(
            password_reset_token: BCrypt::Password.create(token),
            password_reset_sent_at: Time.current
          )
          PasswordResetMailerJob.perform_later(employee.id, token)
        end

        # Always return success to prevent email enumeration
        render_success({ message: "If that email is registered, you will receive a reset link." })
      end

      # PUT /api/v1/auth/reset_password
      def reset_password
        employee = Employee.active.find_by(password_reset_token: params[:token])

        unless employee&.pending_reset?
          return render json: error_response(
            "Invalid Token", "Password reset token is invalid or has expired",
            status: 422
          ), status: :unprocessable_entity
        end

        if employee.update(
          password:              params[:password],
          password_confirmation: params[:password_confirmation],
          password_reset_token:  nil,
          password_reset_sent_at: nil
        )
          render_success({ message: "Password has been reset successfully." })
        else
          render_record_errors(employee)
        end
      end

      # PUT /api/v1/auth/change_password
      def change_password
        unless current_employee.authenticate(params[:current_password])
          return render json: error_response(
            "Forbidden", "Current password is incorrect", status: 403
          ), status: :forbidden
        end

        if current_employee.update(
          password: params[:password],
          password_confirmation: params[:password_confirmation]
        )
          render_success({ message: "Password changed successfully." })
        else
          render_record_errors(current_employee)
        end
      end

      private

      def extract_token
        header = request.headers["Authorization"]
        header&.start_with?("Bearer ") ? header.split(" ").last : nil
      end

      def login_payload(employee, token)
        {
          token:      token,
          expires_at: 24.hours.from_now.iso8601,
          employee: {
            id:              employee.id,
            employee_number: employee.employee_number,
            full_name:       employee.full_name,
            work_email:      employee.work_email,
            roles:           employee.roles.active.pluck(:code),
            permissions:     employee.all_permissions
          }
        }
      end
    end
  end
end
