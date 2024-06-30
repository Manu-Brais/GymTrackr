# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module GetClientsQuery
        extend ActiveSupport::Concern

        included do
          field :clients, [Types::ClientType], null: false

          def clients
            authenticate_user!
            authorize!(current_user, :see_coach_clients?)
            current_user.authenticatable.clients
          end
        end
      end
    end
  end
end
