require "spec_helper"

RSpec.describe "GraphQL, GetClientsQuery", type: :request do
  subject(:execute_get_clients_query) do
    post "/graphql", params: {query: query}, headers: {Authorization: "Bearer token"}
  end

  context "when the user is a coach" do
    let(:user) { create(:user, :coach) }
    let(:coach) { user.authenticatable }
    let!(:clients) { create_list(:client, 3, coach: coach) }

    before do
      authenticate_user(user)
      execute_get_clients_query
    end

    it "returns the list of clients" do
      clients_data = response.parsed_body.dig("data", "clients")

      clients_data.each_with_index do |client_data, index|
        expect(client_data["id"]).to eq(clients[index].id.to_s)
        expect(client_data["name"]).to eq(clients[index].name)
        expect(client_data["surname"]).to eq(clients[index].surname)
      end
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
          id
          name
          surname
        }
      }
    GQL
  end
end
