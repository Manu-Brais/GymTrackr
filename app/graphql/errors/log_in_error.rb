module Errors
  class LogInError < GraphQL::ExecutionError
    def initialize(message)
      super("Log in error: #{message}")
    end
  end
end
