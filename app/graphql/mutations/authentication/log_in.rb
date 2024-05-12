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
        {token: token, user: user}
      end

      private

      def generate_token(user)
        ::Authentication::JwtToken::CreateService.call(user)
      end
    end
  end
end
