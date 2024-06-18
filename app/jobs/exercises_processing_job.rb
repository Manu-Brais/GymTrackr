# frozen_string_literal: true

require "streamio-ffmpeg"

class ExercisesProcessingJob < ApplicationJob
  queue_as :default

  def perform(exercise_id, video_path)
    options = {
      resolution: "850x480",
      video_bitrate: 1000,
      audio_bitrate: 128,
      custom: %w[-crf 20]  # <-- Quality: lower is better quality but bigger file default is 23
    }

    Exercises::VideoProcessingService.call(exercise_id, video_path, options)
  end
end
