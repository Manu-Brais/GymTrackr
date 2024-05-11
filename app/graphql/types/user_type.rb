class Types::UserType < Types::BaseObject
  field :id, ID, null: false
  field :email, String, null: false
  field :password, String, null: false

  # Este field será o encargado de discernir que clase de user é o que se está a autenticar (podemos darlle unha volta, pero a idea e esta
  field :authenticatable, Types::AuthenticatableType, null: false, method: :authenticatable
end
