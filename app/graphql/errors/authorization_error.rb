module Errors
  class AuthorizationError < GraphQL::ExecutionError
    def initialize(message)
      super("Autorization error: #{message}")
    end
  end
end
