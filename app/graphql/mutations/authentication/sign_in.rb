module Mutations
  module Authentication
    class SignIn < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(email:, password:)
        user = User.find_by(email: email)

        if user&.authenticate(password)
          token = generate_token(user)
          {token: token, user: user, errors: []}
        else
          {token: nil, user: nil, errors: ["Invalid email or password"]}
        end
      end

      private

      def generate_token(user)
        "TEST TOKEN"
        # Implementa la lógica para generar un token (JWT o similar)
        # Ejemplo: JWT.encode(payload, secret_key, 'HS256')
      end
    end
  end
end
