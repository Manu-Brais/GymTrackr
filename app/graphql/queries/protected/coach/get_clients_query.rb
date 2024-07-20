# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module GetClientsQuery
        extend ActiveSupport::Concern

        included do
          field :clients, Types::ClientConnectionType, null: false, connection: true do
            argument :search, String, required: false
          end

          def clients(search: nil)
            authorize!(current_user, :see_coach_clients?)

            return current_coach.clients unless search.present?

            ::Client.fuzzy_search(search).where(coach_id: current_coach.id)
          end
        end
      end
    end
  end
end
