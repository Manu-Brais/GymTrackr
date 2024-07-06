# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module ExercisesQuery
        extend ActiveSupport::Concern

        included do
          field :exercises, Types::ExerciseConnectionType, null: false, connection: true

          def exercises
            authenticate_user!
            authorize!(current_user, :see_coach_exercises?)
            current_user.authenticatable.exercises
          end
        end
      end
    end
  end
end
