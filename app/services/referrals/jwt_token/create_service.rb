# frozen_string_literal: true

module Referrals
  module JwtToken
    class CreateService < DryService
      attr_reader :user, :expiration

      def initialize(user, expiration: nil)
        @user = user
        @expiration = expiration || 24.hours.from_now.to_i
      end

      def call
        yield validate_user
        ecdsa_key = yield initialize_ecdsa_key
        payload = yield generate_payload(ecdsa_key)
        generate_token(ecdsa_key, payload)
      end

      private

      VALID_TO_CREATE_REFFERAL = "Coach"
      TOKEN_PURPOSE = "refferal"

      def validate_user
        return Failure("You are not able to perform this action") unless user.authenticatable_type == VALID_TO_CREATE_REFFERAL

        Success()
      end

      def initialize_ecdsa_key
        Try[OpenSSL::PKey::ECError] do
          ec_key = ENV["ECDSA_KEY"]
          OpenSSL::PKey::EC.new(ec_key)
        end.to_result.or do |error|
          Failure("ECDSA key - #{error.message}")
        end
      end

      def generate_payload(ecdsa_key)
        Try do
          {
            user_id: user.id,
            valid_for: TOKEN_PURPOSE,
            token_ulid: ULID.generate,
            exp: expiration
          }
        end.to_result.or do |error|
          Failure("Payload generation failed: #{error.message}")
        end
      end

      def generate_token(ecdsa_key, payload)
        Try[JWT::EncodeError, ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid] do
          jwt = JWT.encode(payload, ecdsa_key, "ES256")
          ReferralToken.create!(id: payload[:token_ulid], user_id: payload[:user_id])
          jwt
        end.to_result.or do |error|
          Failure("Token generation failed: #{error.message}")
        end
      end
    end
  end
end
