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
        ecdsa_key = OpenSSL::PKey::EC.generate("prime256v1")
        payload = {data: user.email}
        JWT.encode(payload, ecdsa_key, "ES256")
      end
    end
  end
end
