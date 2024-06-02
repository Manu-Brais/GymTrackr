# frozen_string_literal: true

module Queries
  module Protected
    module Coach
      module GetReferralQuery
        extend ActiveSupport::Concern

        included do
          field :get_referral, Types::ReferralType, null: false

          def get_referral
            authorize!(current_user, :get_referral_token?)

            referral_token = current_user
              .authenticatable
              .referral_token

            {
              referral_token: referral_token.id
            }
          end
        end
      end
    end
  end
end
