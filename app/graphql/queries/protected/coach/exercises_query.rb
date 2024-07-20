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
            authorize!(current_user, :see_coach_exercises?)

            return current_user.authenticatable.exercises unless search.present?

            ::Exercise.fuzzy_search(search).where(coach_id: current_user.authenticatable.id)
          end
        end
      end
    end
  end
end
