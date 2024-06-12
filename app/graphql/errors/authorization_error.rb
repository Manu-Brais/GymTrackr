module Errors
  class AuthorizationError < GraphQL::ExecutionError
    def initialize(message)
      super("Authorization error: #{message}")
    end
  end
end
