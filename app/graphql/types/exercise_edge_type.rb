# frozen_string_literal: true

module Types
  class ExerciseEdgeType < Types::BaseObject
    field :node, Types::ExerciseType, null: false
    field :cursor, String, null: false
  end
end
