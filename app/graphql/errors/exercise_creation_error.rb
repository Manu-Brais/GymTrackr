module Errors
  class ExerciseCreationError < GraphQL::ExecutionError
    def initialize(message)
      super(message)
    end
  end
end
