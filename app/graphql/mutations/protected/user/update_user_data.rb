# frozen_string_literal: true

module Mutations
  module Protected
    module User
      class UpdateUserData < ProtectedMutation
        argument :name, String, required: false
        argument :surname, String, required: false
        argument :phone, String, required: false
        argument :address, String, required: false

        field :user_data, Types::UserType, null: false

        def resolve(name: nil, surname: nil, phone: nil, address: nil)
          result = ::Profile::UpdateService.call(
            user_id: current_user.id,
            user_data: {
              name: name,
              surname: surname,
              phone: phone,
              address: address
            }
          )

          raise Errors::UserDataUpdateError, result.failure if result.failure?

          {user_data: current_user}
        end
      end
    end
  end
end
