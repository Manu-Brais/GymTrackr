# frozen_string_literal: true

module Exercises
  class CreateService < DryService
    # Remember to define tests for this service
    def initialize(coach_id, title, description, video_file)
      @coach_id = coach_id
      @title = title
      @description = description
      @video_file = video_file
    end

    def call
      exercise = yield initialize_exercise
      yield attach_video(exercise)
      persist(exercise)
    end

    private

    def initialize_exercise
      Try[ActiveRecord::RecordInvalid] do
        Exercise.new(
          coach_id: @coach_id,
          title: @title,
          description: @description,
          video_status: :enqueued
        )
      end.to_result
    end

    def attach_video(exercise)
      Try[ActiveRecord::RecordInvalid] do
        exercise.video.attach(
          io: @video_file,
          filename: @video_file.original_filename
        )
      end.to_result
    end

    def persist(exercise)
      return Failure(exercise.errors.full_messages) unless exercise.save

      Success(exercise)
    end
  end
end
