module Mutations
  module Authentication
    class LogIn < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :user, Types::UserType, null: true

      def resolve(email:, password:)
        user = User.find_by(email: email)

        raise Errors::LogInError.new("Incorrect email or password") unless user&.authenticate(password)

        token = generate_token(user)

        raise Errors::LogInError.new(token.failure) if token.failure?

        {token: token.success, user: user}
      end

      private

      def generate_token(user)
        ::Authentication::JwtToken::CreateService.call(user, expiration: 1.day.from_now.to_i)
      end
    end
  end
end
