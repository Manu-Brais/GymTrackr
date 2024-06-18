# frozen_string_literal: true

module Errors
  class ExerciseVideoProcessingError < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end
end
