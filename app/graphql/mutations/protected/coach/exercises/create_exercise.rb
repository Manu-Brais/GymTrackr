# frozen_string_literal: true

module Mutations
  module Protected
    module Coach
      module Exercises
        class CreateExercise < ProtectedMutation
          argument :title, String, required: false
          argument :description, String, required: false
          argument :video_file, ApolloUploadServer::Upload, required: false

          field :exercise, Types::ExerciseType, null: false

          def resolve(title: nil, description: nil, video_file: nil)
            authorize!(current_user, :create_exercise?)
            result = ::Exercises::CreateService.call(
              title,
              description,
              video_file
            )

            raise Errors::ExerciseCreationError, result.failure if result.failure?

            {exercise: result.success}
          end
        end
      end
    end
  end
end
