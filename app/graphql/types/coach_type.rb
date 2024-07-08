module Types
  class CoachType < BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :surname, String, null: true
    field :phone, String, null: true
    field :address, String, null: true
    field :avatar_url, String, null: true
  end
end
