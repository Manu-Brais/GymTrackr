module Types
  class ClientType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :surname, String, null: true
    field :phone, String, null: true
    field :address, String, null: true
  end
end
