# frozen_string_literal: true

class TestFuncJob < ApplicationJob
  queue_as :default

  def perform(msg)
    sleep 2
    Rails.logger.info "TestFuncJob: #{msg}"
    puts "TestFuncJob: #{msg}"
  end
end
