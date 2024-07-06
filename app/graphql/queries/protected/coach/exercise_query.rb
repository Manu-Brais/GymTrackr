# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module ExerciseQuery
        extend ActiveSupport::Concern

        included do
          field :exercise, Types::ExerciseType, null: true do
            argument :id, ::GraphQL::Types::ID, required: true
          end

          def exercise(id:)
            authenticate_user!
            authorize!(current_user, :see_coach_exercises?)
            current_user.authenticatable.exercises.find(id)
          end
        end
      end
    end
  end
end
