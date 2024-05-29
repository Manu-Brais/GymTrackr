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
        user = ::Authentication::SignUpService.call(email, password, password_confirmation, type, referral_token)
        raise Errors::AuthenticationError.new(user.failure) if user.failure?

        token = generate_jwt(user)
        {user: user.success, token: token.success}
      end

      private

      def generate_jwt(user)
        ::Authentication::JwtToken::CreateService.call(user, expiration: 7.day.from_now.to_i)
      end
    end
  end
end
