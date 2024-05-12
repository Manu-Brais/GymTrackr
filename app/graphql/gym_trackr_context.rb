# frozen_string_literal: true

class GymTrackrContext < GraphQL::Query::Context
  def token
    token = fetch(:token, nil)

    raise Errors::AuthenticationError, token.failure if token.failure?

    token.success
  end

  def current_user?
    return false unless token

    true
  end

  def current_user_id
    token.fetch("user_id", nil)
  end

  def current_user
    return unless current_user_id

    @current_user ||= User.find(current_user_id)
  end
end
