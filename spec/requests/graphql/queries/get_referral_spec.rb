require "spec_helper"

RSpec.describe "GraphQL, get_referral Query", type: :request do
  subject(:execute_get_referal_query) do
    post "/graphql", params: {query: query}, headers: {Authorization: "Bearer token"}
  end

  context "when the user is a coach" do
    let(:user) { create(:user, :coach) }
    let(:coach) { user.authenticatable }
    let!(:referral_token) { create(:referral_token, coach: coach) }

    before do
      authenticate_user(user)
      execute_get_referal_query
    end

    it "returns the referral token" do
      expect(response.parsed_body.dig("data", "getReferral")).to eq({
        "referralToken" => referral_token.id
      })
    end
  end

  context "when the user is a client" do
    let(:user) { create(:user, :client) }

    before do
      authenticate_user(user)
      execute_get_referal_query
    end

    it "returns the referral token" do
      expect(response.parsed_body.dig("errors").first.dig("message"))
        .to eq("Autorization error: this user is not allowed to get_referral_token?")
    end
  end

  def query
    <<~GQL
      query {
        getReferral {
          referralToken
        }
      }
    GQL
  end
end
