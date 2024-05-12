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
        pem_file = yield read_pem_file
        ecdsa_key = yield initialize_ecdsa_key(pem_file)
        payload = yield generate_payload(ecdsa_key)
        yield generate_token(ecdsa_key, payload)
      end

      private

      PEM_FILE_PATH = "ecdsa_key.pem"

      def read_pem_file
        Try[Errno::ENOENT] do
          File.read(PEM_FILE_PATH)
        end.to_result.or do |error|
          Failure("PEM file reading failed: #{error.message}")
        end
      end

      def initialize_ecdsa_key(pem_file)
        Try[OpenSSL::PKey::ECError] do
          OpenSSL::PKey::EC.new(pem_file)
        end.to_result.or do |error|
          Failure("ECDSA key initialization failed: #{error.message}")
        end
      end

      def generate_payload(ecdsa_key)
        Try do
          {
            user_id: user.id,
            type: user.authenticatable_type,
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
