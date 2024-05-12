require "rails_helper"

RSpec.describe Authentication::JwtToken::DecoderService do
  subject(:service) { described_class.call(bearer_token) }

  let(:user) { create(:user) }
  let!(:bearer_token) { ::Authentication::JwtToken::CreateService.call(user) }

  describe "#call" do
    context "when all steps succeed" do
      before do
        allow(File).to receive(:read).and_return("fake_pem_content")
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(JWT)
          .to receive(:decode)
          .with(any_args)
          .and_return([{"user_id" => user.id, "type" => user.authenticatable_type, "exp" => 1000}])
      end

      it "returns the decoded payload" do
        expect(service.success)
          .to a_hash_including("user_id" => user.id, "type" => user.authenticatable_type, "exp" => 1000)
      end
    end

    context "when PEM file reading fails" do
      before do
        allow(File).to receive(:read).and_raise(Errno::ENOENT)
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("PEM file - No such file or directory")
      end
    end

    context "when ECDSA key initialization fails" do
      before do
        allow(File).to receive(:read).and_return("fake_pem_content")
        allow(OpenSSL::PKey::EC).to receive(:new).and_raise(OpenSSL::PKey::ECError, "invalid key")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("ECDSA key - invalid key")
      end
    end

    context "when token decoding fails" do
      before do
        allow(File).to receive(:read).and_return("fake_pem_content")
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(JWT).to receive(:decode).and_raise(JWT::DecodeError, "invalid token")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("JWT - invalid token")
      end
    end
  end
end
