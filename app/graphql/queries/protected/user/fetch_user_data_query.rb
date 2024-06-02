# frozen_string_literal: true

module Queries
  module Protected
    module User
      module FetchUserDataQuery
        extend ActiveSupport::Concern

        included do
          field :fetch_user_data, Types::UserType, null: false

          def fetch_user_data
            current_user
          end
        end
      end
    end
  end
end
