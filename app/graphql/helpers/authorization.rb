# frozen_string_literal: true

module Helpers
  module Authorization
    extend ActiveSupport::Concern

    def authenticate_user!
      context.authenticate_user!
    end

    def authorize!(record, query)
      authenticate_user!
      context.authorize(record, query)
    end
  end
end
