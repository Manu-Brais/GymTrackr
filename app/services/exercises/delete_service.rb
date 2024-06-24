# frozen_string_literal: true

module Exercises
  class DeleteService < DryService
    def initialize(coach_id, id)
      @coach_id = coach_id
      @id = id
    end

    def call
      exercise = yield find_exercise
      yield delete_exercise(exercise)
      Success(true)
    end

    private

    def find_exercise
      Try[ActiveRecord::RecordNotFound] do
        coach = Coach.find(@coach_id)
        coach.exercises.find(@id)
      end.or { |e| Failure(e) }
    end

    def delete_exercise(exercise)
      Try[ActiveRecord::RecordNotDestroyed] do
        exercise.destroy!
      end
        .bind { Success() }
        .or { |e| Failure("Error deleting exercise #{exercise.id}") }
    end
  end
end
