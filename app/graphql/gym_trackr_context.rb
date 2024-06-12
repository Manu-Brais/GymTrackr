# frozen_string_literal: true

class GymTrackrContext < GraphQL::Query::Context
  include Pundit::Authorization

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

    begin
      @current_user ||= User.find(current_user_id)
    rescue ActiveRecord::RecordNotFound
      raise Errors::AuthenticationError, "User not found"
    end
  end

  def authorize(record, query)
    policy = Pundit.policy!(current_user, record)
    raise Errors::AuthorizationError, "this #{record.class.name.downcase} is not allowed to #{query}" unless policy.public_send(query)

    true
  end
end
