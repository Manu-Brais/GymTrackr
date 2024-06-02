module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :password, String, null: true
    field :type, String, null: true

    field :authenticatable, Types::AuthenticatableType, null: false, method: :authenticatable

    def type
      object.coach? ? "coach" : "client"
    end
  end
end
