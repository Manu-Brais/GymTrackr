# frozen_string_literal: true

module Exercises
  class VideoProcessingService < DryService
    def initialize(exercise_id, video_path, options = {})
      @exercise_id = exercise_id
      @video_path = video_path
      @options = options
    end

    def call
      exercise = yield find_exercise(@exercise_id)
      yield check_video_status(exercise)
      output_path = yield set_output_path(exercise)
      yield process_video(exercise, @video_path, output_path, @options)
      thumbnail_path = yield capture_thumbnail(@video_path, exercise)
      yield attach_thumbnail(exercise, thumbnail_path)
      yield cleanup_tmp_video(@video_path)
      attach_video(exercise, output_path)
    end

    private

    def find_exercise(exercise_id)
      Try[ActiveRecord::RecordNotFound] do
        Exercise.find(exercise_id)
      end.or { |e| Failure(e) }
    end

    def check_video_status(exercise)
      return Failure("Video already processed.") if exercise.processed?

      Success()
    end

    def set_output_path(exercise)
      Success("#{Rails.root}/tmp/output_#{exercise.id}.mp4")
    end

    def process_video(exercise, input_path, output_path, options)
      movie = FFMPEG::Movie.new(input_path)

      exercise.update!(video_status: :processing)
      transcode_result = Try[FFMPEG::Error] do
        movie.transcode(output_path, options)
      end

      transcode_result.or do |e|
        exercise.update!(video_status: :failed)
        Failure(e)
      end
    end

    def capture_thumbnail(input_path, exercise)
      thumbnail_path = "#{Rails.root}/tmp/thumbnail_#{exercise.id}.jpg"
      movie = FFMPEG::Movie.new(input_path)

      capture_result = Try[FFMPEG::Error] do
        movie.screenshot(thumbnail_path, seek_time: 2)
      end

      capture_result.or { |e| Failure(e) }
      Success(thumbnail_path)
    end

    def attach_thumbnail(exercise, thumbnail_path)
      return Failure("Thumbnail not found.") unless File.exist?(thumbnail_path)

      result = Try[ActiveStorage::FileNotFoundError, ActiveRecord::RecordInvalid] do
        ActiveRecord::Base.transaction do
          exercise.thumbnail.attach(io: File.open(thumbnail_path), filename: "thumbnail_#{exercise.id}.jpg")
          File.delete(thumbnail_path)
        end
      end

      result
        .bind { Success("Thumbnail captured successfully. 📸") }
        .or { |e| Failure(e) }
    end

    def cleanup_tmp_video(video_path)
      Try[Errno::ENOENT] do
        File.delete(video_path)
      end.or { |e| Failure(e) }
    end

    def attach_video(exercise, output_path)
      return Failure("Processed video not found.") unless File.exist?(output_path)

      result = Try[ActiveStorage::FileNotFoundError, ActiveRecord::RecordInvalid] do
        ActiveRecord::Base.transaction do
          exercise.video.attach(io: File.open(output_path), filename: "processed_#{exercise.id}")
          File.delete(output_path)
        end

        exercise.update!(video_status: :processed)
      end

      result
        .bind { Success("Video processed successfully. 🫡") }
        .or do |e|
          exercise.update!(video_status: :failed)
          Failure(e)
        end
    end
  end
end
