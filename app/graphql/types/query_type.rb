# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include Helpers::Authorization
    include Helpers::Context
    include Queries::Protected::Coach::GetReferralQuery
    include Queries::Protected::Coach::ExercisesQuery
    include Queries::Protected::User::FetchUserDataQuery
    include Queries::Protected::Coach::GetClientsQuery
    include Queries::Protected::Coach::GetClientInfoQuery

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end
  end
end
