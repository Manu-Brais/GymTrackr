# frozen_string_literal: true

module Authentication
  module JwtToken
    class DecoderService < DryService
      attr_reader :bearer_token

      def initialize(bearer_token)
        @bearer_token = bearer_token
      end

      def call
        pem_file = yield read_pem_file
        ecdsa_key = yield initialize_ecdsa_key(pem_file)
        decode_token(ecdsa_key)
      end

      private

      PEM_FILE_PATH = "ecdsa_key.pem"

      def read_pem_file
        Try[Errno::ENOENT] do
          File.read(PEM_FILE_PATH)
        end.to_result.or do |error|
          Failure("PEM file - #{error.message}")
        end
      end

      def initialize_ecdsa_key(pem_file)
        Try[OpenSSL::PKey::ECError] do
          OpenSSL::PKey::EC.new(pem_file)
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
