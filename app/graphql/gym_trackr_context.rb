# frozen_string_literal: true

class GymTrackrContext < GraphQL::Query::Context
  def token
    token = fetch(:token, nil)

    raise Errors::LogInError.new(token.failure) if token.failure?

    token.success
  end

  def current_user_id
    token["user_id"]
  end

  def current_user
    return unless current_user_id

    @current_user ||= User.find(current_user_id)
  end
end
