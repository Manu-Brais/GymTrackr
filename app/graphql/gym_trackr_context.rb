# frozen_string_literal: true

class GymTrackrContext < GraphQL::Query::Context
  def token
    token = fetch(:token)

    raise Errors::AuthenticationError, token.failure if token.failure?

    token.success
  end

  def authenticate_user!
    raise Errors::AuthenticationError, "You need to authenticate to perform this action" unless authenticated?
  end

  def authenticated?
    token && token.fetch("valid_for", nil) == "authentication"
  end

  def current_user_id
    token.fetch("user_id", nil)
  end

  def current_user
    return unless current_user_id

    @current_user ||= User.find(current_user_id)
  end
end
