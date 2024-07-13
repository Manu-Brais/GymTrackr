# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module ExercisesQuery
        extend ActiveSupport::Concern

        included do
          field :exercises, Types::ExerciseConnectionType, null: false, connection: true do
            argument :search, String, required: false
          end

          def exercises(search: nil)
            authenticate_user!
            authorize!(current_user, :see_coach_exercises?)

            exercises = current_user.authenticatable.exercises
            exercises = exercises.where("title ILIKE ?", "%#{search}%") if search.present?
            exercises
          end
        end
      end
    end
  end
end
