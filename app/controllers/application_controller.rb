class ApplicationController < ActionController::API
  include Authorizable
  include Paginatable
  include ApiResponse

  rescue_from Errors::AuthenticationError, with: :render_unauthorized
  rescue_from Errors::AuthorizationError,  with: :render_forbidden
  rescue_from Errors::BusinessLogicError,  with: :render_unprocessable
  rescue_from ActiveRecord::RecordNotFound,      with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from ActiveRecord::RecordInvalid,       with: :render_invalid_record

  private

  def render_unauthorized(e)
    render json: error_response("Unauthorized", e.message, status: 401, code: "UNAUTHORIZED"),
           status: :unauthorized
  end

  def render_forbidden(e)
    render json: error_response("Forbidden", e.message, status: 403, code: "FORBIDDEN"),
           status: :forbidden
  end

  def render_not_found(e)
    render json: error_response("Not Found", e.message, status: 404, code: "NOT_FOUND"),
           status: :not_found
  end

  def render_bad_request(e)
    render json: error_response("Bad Request", e.message, status: 400, code: "BAD_REQUEST"),
           status: :bad_request
  end

  def render_unprocessable(e)
    render json: error_response("Business Logic Error", e.message, status: 422, code: "BUSINESS_LOGIC_ERROR"),
           status: :unprocessable_entity
  end

  def render_invalid_record(e)
    render_record_errors(e.record)
  end
end
