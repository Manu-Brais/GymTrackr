module Types
  class ClientType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :surname, String, null: true
    field :email, String, null: true
    field :phone, String, null: true
    field :address, String, null: true
    field :avatar_url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true

    def email
      object.user.email
    end
  end
end
