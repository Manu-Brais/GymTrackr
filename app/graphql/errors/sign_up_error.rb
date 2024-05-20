module Errors
  class SignUpError < GraphQL::ExecutionError
    def initialize(message)
      super(message, extensions: {code: "SIGN_UP_ERROR"})
    end
  end
end
