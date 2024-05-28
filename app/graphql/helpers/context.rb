# frozen_string_literal: true

module Helpers
  module Context
    extend ActiveSupport::Concern

    def current_user
      context.current_user
    end
  end
end
