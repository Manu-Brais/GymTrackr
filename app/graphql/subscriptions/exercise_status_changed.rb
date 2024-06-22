# frozen_string_literal: true

module Subscriptions
  class ExerciseStatusChanged < BaseSubscription
    argument :exercise_id, ID, required: true

    field :exercise, Types::ExerciseType, null: false

    def subscribe(exercise_id:)
      exercise = Exercise.find(exercise_id)
      {exercise: exercise}
    end

    def update(exercise_id:)
      exercise = Exercise.find(exercise_id)
      {exercise: exercise}
    end
  end
end
