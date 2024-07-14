module Errors
  class UserDataUpdateError < GraphQL::ExecutionError
    def initialize(message)
      super
    end
  end
end
