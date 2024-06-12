# frozen_string_literal: true

module Authentication
  module JwtToken
    class CreateService < DryService
      attr_reader :user, :expiration

      def initialize(user, expiration: 24.hours.from_now.to_i)
        @user = user
        @expiration = expiration
      end

      def call
        ecdsa_key = yield initialize_ecdsa_key
        payload = yield generate_payload(ecdsa_key)
        generate_token(ecdsa_key, payload)
      end

      private

      TOKEN_PURPOSE = "authentication"

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
            user_type: user.coach? ? "coach" : "client",
            valid_for: TOKEN_PURPOSE,
            exp: expiration
          }
        end.to_result.or do |error|
          Failure("Payload generation failed: #{error.message}")
        end
      end

      def generate_token(ecdsa_key, payload)
        Try[JWT::EncodeError, Errno::ENOENT] do
          JWT.encode(payload, ecdsa_key, "ES256")
        end.to_result.or do |error|
          Failure("Token generation failed: #{error.message}")
        end
      end
    end
  end
end
