# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module GetClientInfoQuery
        extend ActiveSupport::Concern
        include Dry::Monads[:result, :try]

        included do
          field :client, Types::ClientType, null: false do
            argument :id, String, required: true
          end

          # TODO: change authorize policy to see_coach_client?
          def client(id:)
            authorize!(current_user, :see_coach_clients?)

            Try[ActiveRecord::RecordNotFound] do
              current_user.authenticatable.clients.find(id)
            end.to_result.or do |e|
              raise GraphQL::ExecutionError, e.message
            end.value!
          end
        end
      end
    end
  end
end
