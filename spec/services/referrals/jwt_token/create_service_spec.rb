require "spec_helper"

RSpec.describe Referrals::JwtToken::CreateService do
  subject(:result) { service.call }

  describe "#call" do
    let(:user) { create(:user, authenticatable_type: "Coach") }
    let(:service) { described_class.new(user) }

    context "when the user is a coach" do
      before do
        allow(ENV).to receive(:[]).with("ECDSA_KEY").and_return("your_ecdsa_private_key")
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(JWT).to receive(:encode).and_return("mock_jwt_token")
      end

      it "successfully creates a referral JWT token" do
        expect(result).to be_success
        expect(result.value!).to eq("mock_jwt_token")
        expect(ReferralToken.where(user_id: user.id).count).to eq(1)
      end
    end

    context "when the user is not a coach" do
      let(:user) { build(:user, authenticatable_type: "Client") }

      it "fails to create a referral JWT token" do
        expect(result).to be_failure
        expect(result.failure).to eq("You are not able to perform this action")
      end
    end

    context "when the ECDSA key is invalid" do
      before do
        allow(ENV).to receive(:[]).with("ECDSA_KEY").and_return("invalid_ecdsa_key")
      end

      it "handles ECDSA key errors" do
        expect(result).to be_failure
        expect(result.failure).to include("ECDSA key -")
      end
    end

    context "when token generation fails" do
      before do
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(JWT).to receive(:encode).and_raise(JWT::EncodeError, "invalid token")
      end

      it "handles JWT encoding errors" do
        expect(result).to be_failure
        expect(result.failure).to include("Token generation failed:")
      end
    end

    context "when creating the ReferralToken record fails" do
      before do
        allow(ENV).to receive(:[]).with("ECDSA_KEY").and_return("your_ecdsa_private_key")
        allow(OpenSSL::PKey::EC).to receive(:new).and_return("fake_ecdsa_key")
        allow(JWT).to receive(:encode).and_return("mock_jwt_token")
        allow(ReferralToken).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it "handles ActiveRecord errors during token creation" do
        expect(result).to be_failure
        expect(result.failure).to include("Token generation failed:")
      end
    end
  end
end
