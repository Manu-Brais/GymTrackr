# frozen_string_literal: true

module Mutations
  module Protected
    module Coach
      module Exercises
        class DeleteExercise < ProtectedMutation
          argument :id, ID, required: true

          field :success, Boolean, null: false

          def resolve(id:)
            authorize!(current_user, :create_exercise?)
            result = ::Exercises::DeleteService.call(
              current_user.authenticatable_id,
              id
            )

            raise Errors::ExerciseDeleteError, result.failure if result.failure?

            {success: true}
          end
        end
      end
    end
  end
end
