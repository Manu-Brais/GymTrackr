module Mutations
  module Referral
    class GenerateJwt < BaseMutation
      argument :expiration, Integer, required: false

      field :referal_token, String, null: true

      def resolve(expiration: nil)
        context.authenticate_user!

        token = generate_token(context.current_user, expiration: expiration)

        raise Errors::JwtTokenError, token.failure if token.failure?

        {referal_token: token.success}
      end

      private

      def generate_token(user, expiration:)
        ::Referrals::JwtToken::CreateService.call(user, expiration: expiration)
      end
    end
  end
end
