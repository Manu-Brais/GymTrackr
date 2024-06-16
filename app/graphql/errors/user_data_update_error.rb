module Errors
  class UserDataUpdateError < GraphQL::ExecutionError
    def initialize(message)
      super(message)
    end
  end
end
