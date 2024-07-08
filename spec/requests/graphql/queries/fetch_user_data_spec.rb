require "spec_helper"

RSpec.describe "GraphQL, fetch_user_data Query", type: :request do
  subject(:execute_fetch_user_data) do
    post "/graphql", params: {query: query}, headers: {Authorization: "Bearer token"}
  end

  context "when the user is not logged in" do
    before do
      execute_fetch_user_data
    end

    it "returns a message error" do
      expect(response.parsed_body.dig("errors").first.dig("message"))
        .to match(/Authentication error: /)
    end
  end

  context "when the user is logged in" do
    before do
      authenticate_user(user)
      user.authenticatable.avatar.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "avatar.jpeg")),
        filename: "avatar.jpeg",
        content_type: "image/jpeg"
      )
      execute_fetch_user_data
    end

    context "when the user is a coach" do
      let(:user) { create(:user, :coach) }

      it "returns the coach data" do
        expect(response.parsed_body.dig("data", "fetchUserData")).to eq({
          "email" => user.email,
          "type" => "coach",
          "authenticatable" => {
            "id" => user.authenticatable.id,
            "name" => user.authenticatable.name,
            "surname" => user.authenticatable.surname,
            "phone" => user.authenticatable.phone,
            "address" => user.authenticatable.address,
            "avatarUrl" => user.authenticatable.avatar_url
          }
        })
      end
    end

    context "when the user is a client" do
      let(:user) { create(:user, :client) }

      it "returns the client data" do
        expect(response.parsed_body.dig("data", "fetchUserData")).to eq({
          "email" => user.email,
          "type" => "client",
          "authenticatable" => {
            "id" => user.authenticatable.id,
            "name" => user.authenticatable.name,
            "surname" => user.authenticatable.surname,
            "phone" => user.authenticatable.phone,
            "address" => user.authenticatable.address,
            "avatarUrl" => user.authenticatable.avatar_url
          }
        })
      end
    end
  end

  def query
    <<~GQL
      query {
        fetchUserData {
          email
          type
          authenticatable {
            ... on Coach {
              id
              name
              surname
              phone
              address
              avatarUrl
            }
            ... on Client {
              id
              name
              surname
              phone
              address
              avatarUrl
            }
          }
        }
      }
    GQL
  end
end
