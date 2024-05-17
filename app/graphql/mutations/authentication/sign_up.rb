module Mutations
  module Authentication
    class SignUp < BaseMutation
      argument :name, String, required: true
      argument :surname, String, required: true
      argument :phone, String, required: true
      argument :address, String, required: true
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :type, String, required: true

      field :user, Types::UserType, null: true
      field :token, String, null: true

      def resolve(name:, surname:, phone:, address:, email:, password:, password_confirmation:, type:)
        authenticatable = set_authenticatable(name, surname, phone, address, type)
        raise Errors::SignUpError.new(authenticatable.errors.full_messages) unless authenticatable.valid?

        user = User.new(
          email: email,
          password: password,
          password_confirmation: password_confirmation,
          authenticatable: authenticatable
        )
        raise Errors::SignUpError.new(user.errors.full_messages) unless user.save

        token = generate_token(user)
        raise Errors::SignUpError.new(token.failure) if token.failure?

        {user: user, token: token.success}
      end

      private

      def set_authenticatable(name, surname, phone, address, type)
        case type
        when "coach"
          Coach.new(name: name, surname: surname, phone: phone, address: address)
        when "client"
          Client.new(name: name, surname: surname, phone: phone, address: address)
        else
          raise Errors::SignUpError.new("Invalid Authenticatable type, valid types: coach, client")
        end
      end

      def generate_token(user)
        ::Authentication::JwtToken::CreateService.call(user, expiration: 7.day.from_now.to_i)
      end
    end
  end
end
