# frozen_string_literal: true

module Authentication
  module JwtToken
    class DecoderService < DryService
      attr_reader :bearer_token

      def initialize(bearer_token)
        @bearer_token = bearer_token
      end

      def call
        ecdsa_key = yield initialize_ecdsa_key
        decode_token(ecdsa_key)
      end

      private

      def initialize_ecdsa_key
        Try[OpenSSL::PKey::ECError] do
          ec_key = ENV["ECDSA_KEY"]
          OpenSSL::PKey::EC.new(ec_key)
        end.to_result.or do |error|
          Failure("ECDSA key - #{error.message}")
        end
      end

      def decode_token(ecdsa_key)
        Try[JWT::DecodeError, JWT::ExpiredSignature] do
          JWT.decode(bearer_token, ecdsa_key, true, algorithm: "ES256")[0]
        end.to_result.or do |error|
          Failure("JWT - #{error.message}")
        end
      end
    end
  end
end
