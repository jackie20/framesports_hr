class PasswordResetMailerJob < ApplicationJob
  queue_as :mailers

  def perform(employee_id, reset_token)
    employee = Employee.find_by(id: employee_id)
    return unless employee&.pending_reset?

    # In production, send via ActionMailer
    Rails.logger.info("Password reset for #{employee.work_email}: token #{reset_token[0..8]}...")
    # EmployeeMailer.password_reset(employee, reset_token).deliver_now
  end
end
