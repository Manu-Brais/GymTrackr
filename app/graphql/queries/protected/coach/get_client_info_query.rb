# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module GetClientInfoQuery
        extend ActiveSupport::Concern

        included do
          field :client, Types::ClientType, null: false do
            argument :id, String, required: true
          end

          def client(id:)
            authenticate_user!
            authorize!(current_user, :see_coach_clients?)
            # TODO: change authorize policy to see_coach_client?
            begin
              current_user.authenticatable.clients.find(id)
            rescue ActiveRecord::RecordNotFound => e
              raise GraphQL::ExecutionError, e.message
            end
          end
        end
      end
    end
  end
end
