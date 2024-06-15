# frozen_string_literal: true

module Exercises
  class CreateService < DryService
    def initialize(coach_id, title, description, video_file)
      @coach_id = coach_id
      @title = title
      @description = description
      @video_file = video_file
    end

    def call
      exercise = yield create_exercise
      tmp_video = yield save_tmp_video(@video_file)
      enqueue_video_processing(exercise, tmp_video)
    end

    private

    def create_exercise
      Try[ActiveRecord::RecordInvalid] do
        Exercise.create!(
          coach_id: @coach_id,
          title: @title,
          description: @description,
          video_status: :initialized
        )
      end.or { |e| Failure(e.record.errors.full_messages) }
    end

    def save_tmp_video(video_file)
      Try[Errno::ENOENT] do
        video_path = "#{Rails.root}/tmp/#{video_file.original_filename}"
        File.binwrite(video_path, video_file.read)

        video_path
      end.or { |e| Failure(e) }
    end

    def enqueue_video_processing(exercise, video_path)
      ExercisesProcessingJob.perform_later(exercise.id, video_path)

      update_result = Try[ActiveRecord::RecordInvalid] do
        exercise.update!(video_status: :enqueued)
      end

      update_result
        .bind { Success(exercise) }
        .or { |e| Failure(e) }
    end
  end
end
