module Errors
  class SignUpError < GraphQL::ExecutionError
    def initialize(message)
      super("Sign up error: #{message}")
    end
  end
end
