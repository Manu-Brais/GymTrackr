# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup, mutation: Mutations::Public::Authentication::SignUp
    field :login, mutation: Mutations::Public::Authentication::LogIn
    field :create_exercise, mutation: Mutations::Protected::Coach::Exercises::CreateExercise
  end
end
