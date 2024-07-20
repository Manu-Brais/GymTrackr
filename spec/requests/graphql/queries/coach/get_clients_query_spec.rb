require "spec_helper"

RSpec.describe "GraphQL, GetClientsQuery", type: :request do
  subject(:execute_get_clients_query) do
    post "/graphql", params: {query: query}, headers: {Authorization: "Bearer token"}
  end

  let(:avatar) { fixture_file_upload("spec/fixtures/files/avatar.jpeg", "image/jpeg") }

  context "when the user is a coach" do
    let(:user) { create(:user, :coach) }
    let(:coach) { user.authenticatable }
    let(:first_client) { create(:user, :client, email: "client#{SecureRandom.uuid}@email.com").authenticatable }
    let(:second_client) { create(:user, :client, email: "client#{SecureRandom.uuid}@email.com").authenticatable }

    before do
      authenticate_user(user)
      first_client.avatar.attach(avatar)
      second_client.avatar.attach(avatar)
      coach.clients << [first_client, second_client]
      execute_get_clients_query
    end

    it "returns the list of clients" do
      clients_data = response.parsed_body.dig("data", "clients", "edges")
      first_client_response = clients_data.first.dig("node")
      second_client_response = clients_data.second.dig("node")

      expect(clients_data.size).to eq(2)

      expect(first_client_response["id"]).to eq(first_client.id.to_s)
      expect(first_client_response["address"]).to eq(first_client.address)
      expect(first_client_response["avatarUrl"]).to eq(first_client.avatar_url)
      expect(first_client_response["name"]).to eq(first_client.name)
      expect(first_client_response["phone"]).to eq(first_client.phone)
      expect(first_client_response["surname"]).to eq(first_client.surname)
      expect(first_client_response["email"]).to eq(first_client.user.email)
      expect(first_client_response["createdAt"]).to eq(first_client.created_at.iso8601)

      expect(second_client_response["id"]).to eq(second_client.id.to_s)
      expect(second_client_response["address"]).to eq(second_client.address)
      expect(second_client_response["avatarUrl"]).to eq(second_client.avatar_url)
      expect(second_client_response["name"]).to eq(second_client.name)
      expect(second_client_response["phone"]).to eq(second_client.phone)
      expect(second_client_response["surname"]).to eq(second_client.surname)
      expect(second_client_response["email"]).to eq(second_client.user.email)
      expect(second_client_response["createdAt"]).to eq(second_client.created_at.iso8601)
    end
  end

  context "when the user is not a coach" do
    let(:user) { create(:user, :client) }

    before do
      authenticate_user(user)
      execute_get_clients_query
    end

    it "returns an authorization error" do
      expect(response.parsed_body.dig("errors").first.dig("message"))
        .to eq("Authorization error: this user is not allowed to see_coach_clients?")
    end
  end

  let(:query) do
    <<~GQL
      query {
        clients {
          edges {
            node {
              id
              address
              avatarUrl
              name
              phone
              surname
              email
              createdAt
            }
          }
        }
      }
    GQL
  end
end
