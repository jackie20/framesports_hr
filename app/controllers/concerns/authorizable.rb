module Authorizable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_employee!
  end

  def require_permission!(*codes)
    return if codes.any? { |c| current_employee.has_permission?(c) }

    render json: error_response(
      "Forbidden",
      "Insufficient permissions. Required: #{codes.join(' or ')}",
      status: 403,
      code: "FORBIDDEN"
    ), status: :forbidden
  end

  def current_employee
    @current_employee ||= Employee.active.find(@jwt_payload["sub"])
  rescue ActiveRecord::RecordNotFound
    raise Errors::AuthenticationError, "Employee account not found or inactive"
  end

  def authenticate_employee!
    token = extract_token
    raise Errors::AuthenticationError, "Authorization token is missing" unless token

    @jwt_payload = JwtService.decode(token)
    raise Errors::AuthenticationError, "Invalid or expired token" unless @jwt_payload
  rescue Errors::AuthenticationError => e
    render json: error_response("Unauthorized", e.message, status: 401, code: "UNAUTHORIZED"),
           status: :unauthorized
  end

  private

  def extract_token
    header = request.headers["Authorization"]
    header&.start_with?("Bearer ") ? header.split(" ").last : nil
  end
end
