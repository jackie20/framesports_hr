module Errors
  class Base                < StandardError; end
  class AuthenticationError < Base; end
  class AuthorizationError  < Base; end
  class RecordNotFound      < Base; end
  class BusinessLogicError  < Base; end
  class ValidationError     < Base
    attr_reader :details

    def initialize(msg = nil, details: {})
      super(msg)
      @details = details
    end
  end
end
