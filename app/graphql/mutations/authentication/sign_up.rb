module Mutations
  module Authentication
    class SignUp < BaseMutation
      # type Types::SignupResult, null: false

      field :user, Types::UserType, null: true
      field :errors, [String], null: true

      argument :name, String, required: true
      argument :surname, String, required: true
      argument :phone, String, required: true
      argument :address, String, required: true
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true
      argument :type, String, required: true

      def resolve(name:, surname:, phone:, address:, email:, password:, password_confirmation:, type:)
        authenticatable = set_authenticatable(name, surname, phone, address, type)
        user = User.new(
          email: email,
          password: password,
          password_confirmation: password_confirmation,
          authenticatable: authenticatable
        )

        if user.save
          {
            user: user,
            errors: nil
          }
        else
          {
            user: nil,
            errors: user.errors.full_messages
          }
        end
      end

      private

      def set_authenticatable(name, surname, phone, address, type)
        case type
        when "coach"
          Coach.new(name: name, surname: surname, phone: phone, address: address)
        when "client"
          Client.new(name: name, surname: surname, phone: phone, address: address)
        end
      end
    end
  end
end
