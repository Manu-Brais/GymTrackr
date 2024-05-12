module Errors
  class JwtTokenError < GraphQL::ExecutionError
    def initialize(message)
      super("JWT - #{message}")
    end
  end
end
