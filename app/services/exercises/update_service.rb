# frozen_string_literal: true

module Exercises
  class UpdateService < DryService
    def initialize(coach_id, id, title, description, video_file)
      @coach_id = coach_id
      @id = id
      @title = title
      @description = description
      @video_file = video_file
    end

    def call
      exercise = yield find_exercise
      updated_exercise = yield update_exercise(exercise)
      if @video_file
        tmp_video = yield save_tmp_video(@video_file)
        enqueue_video_processing(updated_exercise, tmp_video)
      else
        Success(updated_exercise)
      end
    end

    private

    def find_exercise
      Try[ActiveRecord::RecordNotFound] do
        coach = Coach.find(@coach_id)
        coach.exercises.find(@id)
      end.or { |e| Failure(e) }
    end

    def update_exercise(exercise)
      update_params = {}
      update_params[:title] = @title unless @title.nil?
      update_params[:description] = @description unless @description.nil?
      update_params[:video_status] = :initialized if @video_file

      Try[ActiveRecord::RecordInvalid] do
        exercise.update!(update_params)
        exercise
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
