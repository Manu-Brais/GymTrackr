# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup, mutation: Mutations::Authentication::SignUp
    field :login, mutation: Mutations::Authentication::LogIn
    field :generate_referal_token, mutation: Mutations::Referral::GenerateJwt
  end
end
