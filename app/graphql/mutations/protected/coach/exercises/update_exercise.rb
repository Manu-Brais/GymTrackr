# frozen_string_literal: true

module Mutations
  module Protected
    module Coach
      module Exercises
        class UpdateExercise < ProtectedMutation
          argument :id, ID, required: true
          argument :title, String, required: false
          argument :description, String, required: false
          argument :video_file, ApolloUploadServer::Upload, required: false

          field :exercise, Types::ExerciseType, null: false

          def resolve(id:, title: nil, description: nil, video_file: nil)
            authorize!(current_user, :create_exercise?)
            result = ::Exercises::UpdateService.call(
              current_user.authenticatable_id,
              id,
              title,
              description,
              video_file
            )

            raise Errors::ExerciseUpdateError, result.failure if result.failure?

            {exercise: result.success}
          end
        end
      end
    end
  end
end
