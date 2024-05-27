# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
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
      context.authenticate_user!
      # TO-DO: Implement policies with Pundit
      # to check if the current_user is allowed to
      # access the referral token (and other resources)
      referral_token = context.current_user.authenticatable.referral_token
      {
        referral_token: referral_token.id
      }
    end
  end
end
