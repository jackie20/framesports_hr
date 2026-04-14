module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_employee

    def connect
      self.current_employee = find_verified_employee
    end

    private

    def find_verified_employee
      token   = request.params[:token] || request.headers["Authorization"]&.split(" ")&.last
      payload = JwtService.decode(token)
      reject_unauthorized_connection unless payload

      employee = Employee.active.find_by(id: payload["sub"])
      reject_unauthorized_connection unless employee

      employee
    end
  end
end
