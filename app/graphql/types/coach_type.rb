class Types::CoachType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :surname, String, null: false
  field :phone, String, null: false
  field :address, String, null: false
end
