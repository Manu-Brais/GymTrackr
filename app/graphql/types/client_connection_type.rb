# frozen_string_literal: true

module Types
  class ClientConnectionType < Types::BaseObject
    field :edges, [Types::ClientEdgeType], null: false
    field :page_info, Types::PageInfoType, null: false
    field :total_count, Integer, null: false

    def total_count
      object.items.size
    end
  end
end
