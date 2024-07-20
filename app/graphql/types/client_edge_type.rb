# frozen_string_literal: true

module Types
  class ClientEdgeType < Types::BaseObject
    field :node, Types::ClientType, null: false
    field :cursor, String, null: false
  end
end
