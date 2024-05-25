module Mutations
  module Authentication
    class SignUp < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :type, String, required: true
      argument :referral_token, String, required: false, description: "Referral token for the Client type."

      field :user, Types::UserType, null: true
      field :token, String, null: true

      def resolve(email:, password:, password_confirmation:, type:, referral_token: nil)
        authenticatable = set_authenticatable(type)
        validate_and_reffer_coach(authenticatable, referral_token) if type == "client"
        raise Errors::SignUpError.new(authenticatable.errors.full_messages) unless authenticatable.valid?

        user = User.new(
          email: email,
          password: password,
          password_confirmation: password_confirmation,
          authenticatable: authenticatable
        )
        raise Errors::SignUpError.new(user.errors.full_messages) unless user.save

        token = generate_jwt(user)
        raise Errors::SignUpError.new(token.failure) if token.failure?

        generate_referral_token(authenticatable) if type == "coach"
        {user: user, token: token.success}
      end

      private

      def set_authenticatable(type)
        case type
        when "coach"
          Coach.new
        when "client"
          Client.new
        else
          raise Errors::SignUpError.new("Invalid Authenticatable type, valid types: coach, client")
        end
      end

      def validate_and_reffer_coach(authenticatable, referral_token)
        raise Errors::SignUpError.new("Referral token is required for Client type") if referral_token.blank?

        referral = ReferralToken.find_by(id: referral_token)
        raise Errors::SignUpError.new("Invalid referral token") if referral.blank?

        authenticatable.coach = referral.coach
      end

      def generate_referral_token(coach)
        ReferralToken.create(coach: coach)
      end

      def generate_jwt(user)
        ::Authentication::JwtToken::CreateService.call(user, expiration: 7.day.from_now.to_i)
      end
    end
  end
end
