require "rails_helper"

RSpec.describe Authentication::JwtToken::CreateService do
  subject(:service) { described_class.call(user, expiration: expiration) }

  let(:user) { create(:user) }
  let(:expiration) { 24.hours.from_now.to_i }

  describe "#call" do
    context "when all steps succeed" do
      before do
        allow(File).to receive(:read).and_return("fake_pem_content")
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(JWT).to receive(:encode).and_return("fake_jwt_token")
      end

      it "returns the JWT token" do
        expect(service.success).to eq("fake_jwt_token")
      end
    end

    context "when PEM file reading fails" do
      before do
        allow(File).to receive(:read).and_raise(Errno::ENOENT, "file not found")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("PEM file reading failed")
      end
    end

    context "when ECDSA key initialization fails" do
      before do
        allow(File).to receive(:read).and_return("fake_pem_content")
        allow(OpenSSL::PKey::EC).to receive(:new).and_raise(OpenSSL::PKey::ECError, "invalid key")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("ECDSA key initialization failed")
      end
    end

    context "when payload generation fails" do
      before do
        allow(File).to receive(:read).and_return("fake_pem_content")
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(user).to receive(:id).and_raise(StandardError, "unexpected error")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("Payload generation failed")
      end
    end

    context "when token generation fails" do
      before do
        allow(File).to receive(:read).and_return("fake_pem_content")
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(JWT).to receive(:encode).and_raise(JWT::EncodeError, "invalid token")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("Token generation failed")
      end
    end
  end
end
