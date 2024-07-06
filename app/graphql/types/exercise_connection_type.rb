# frozen_string_literal: true

module Types
  class ExerciseConnectionType < Types::BaseObject
    field :edges, [Types::ExerciseEdgeType], null: false
    field :page_info, Types::PageInfoType, null: false
    field :total_count, Integer, null: false

    def total_count
      object.items.size
    end
  end
end
