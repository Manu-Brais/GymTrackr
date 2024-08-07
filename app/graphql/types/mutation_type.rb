# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :signup, mutation: Mutations::Public::Authentication::SignUp
    field :login, mutation: Mutations::Public::Authentication::LogIn
    field :create_exercise, mutation: Mutations::Protected::Coach::Exercises::CreateExercise
    field :delete_exercise, mutation: Mutations::Protected::Coach::Exercises::DeleteExercise
    field :update_exercise, mutation: Mutations::Protected::Coach::Exercises::UpdateExercise
    field :update_user_data, mutation: Mutations::Protected::User::UpdateUserData
  end
end
