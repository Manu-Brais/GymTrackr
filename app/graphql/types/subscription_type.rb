module Types
  class SubscriptionType < GraphQL::Schema::Object
    field :exercise_status_changed, subscription: Subscriptions::ExerciseStatusChanged
  end
end
