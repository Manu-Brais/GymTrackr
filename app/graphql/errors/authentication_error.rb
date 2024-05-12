module Errors
  class AuthenticationError < GraphQL::ExecutionError
    def initialize(message)
      super("Authentication error: #{message}")
    end
  end
end
