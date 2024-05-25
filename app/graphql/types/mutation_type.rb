# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup, mutation: Mutations::Authentication::SignUp
    field :login, mutation: Mutations::Authentication::LogIn
  end
end
