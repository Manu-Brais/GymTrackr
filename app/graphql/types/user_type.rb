module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :password, String, null: true

    field :authenticatable, Types::AuthenticatableType, null: false, method: :authenticatable
  end
end
