module Errors
  class ExerciseCreationError < GraphQL::ExecutionError
    def initialize(message)
      super
    end
  end
end
