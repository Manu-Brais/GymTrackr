module Mutations
  module Public
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
          user = sign_up_user(email, password, password_confirmation, type, referral_token)
          token = generate_jwt(user)

          {user: user, token: token}
        end

        private

        def sign_up_user(email, password, password_confirmation, type, referral_token)
          user_sign_up_result = ::Authentication::SignUpService.call(email, password, password_confirmation, type, referral_token)
          raise Errors::SignUpError, user_sign_up_result.failure if user_sign_up_result.failure?

          user_sign_up_result.success
        end

        def generate_jwt(user)
          jwt_creation_result = ::Authentication::JwtToken::CreateService.call(user, expiration: 7.day.from_now.to_i)
          raise Errors::SignUpError, jwt_creation_result.failure if jwt_creation_result.failure?

          jwt_creation_result.success
        end
      end
    end
  end
end
