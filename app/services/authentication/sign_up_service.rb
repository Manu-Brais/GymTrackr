# frozen_string_literal: true

module Authentication
  class SignUpService < DryService
    def initialize(email, password, password_confirmation, type, referral_token)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
      @type = type
      @referral_token = referral_token
    end

    def call
      authenticatable = yield set_authenticatable(@type)
      yield validate_client_and_refer_coach(authenticatable, @referral_token, @type)
      user = yield create_user(authenticatable, @email, @password, @password_confirmation)
      yield generate_referral_token(authenticatable, @type)
      Success(user)
    end

    private

    def set_authenticatable(type)
      case type
      when "coach"
        Success(Coach.new)
      when "client"
        Success(Client.new)
      else
        Failure("Invalid Authenticatable type, valid types: coach, client")
      end
    end

    def validate_client_and_refer_coach(authenticatable, referral_token, type)
      return Success() if type == "coach"
      return Failure("Referral token is required for Client type") if referral_token.blank?

      referral = ReferralToken.find_by(id: referral_token)
      return Failure("Invalid referral token") if referral.blank? || referral.coach.blank?

      authenticatable.coach = referral.coach
      Success()
    end

    def create_user(authenticatable, email, password, password_confirmation)
      user = User.new(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        authenticatable: authenticatable
      )
      return Failure(user.errors.full_messages) unless user.save

      Success(user)
    end

    def generate_referral_token(coach, type)
      return Success() if type == "client"

      Try[ActiveRecord::RecordInvalid] { ReferralToken.create(coach: coach) }
        .to_result
        .bind { Success() }
        .or(Failure("Failed to generate referral token"))
    end
  end
end
