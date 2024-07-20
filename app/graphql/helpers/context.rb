# frozen_string_literal: true

module Helpers
  module Context
    extend ActiveSupport::Concern

    def current_user
      context.current_user
    end

    def current_coach
      context.current_coach
    end

    def current_client
      context.current_client
    end
  end
end
