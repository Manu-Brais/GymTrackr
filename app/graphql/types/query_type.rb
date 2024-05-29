# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include Helpers::Authorization
    include Helpers::Context

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

    field :get_referral, Types::ReferralType, null: false

    def get_referral
      authorize(current_user, :get_referral_token?)

      referral_token = current_user
        .authenticatable
        .referral_token

      {
        referral_token: referral_token.id
      }
    end
  end
end
