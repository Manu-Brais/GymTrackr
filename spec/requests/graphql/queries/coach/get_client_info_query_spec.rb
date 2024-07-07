require "spec_helper"

RSpec.describe "GraphQL, GetClientInfoQuery", type: :request do
  subject(:execute_get_client_info_query) do
    post "/graphql", params: {query: query, variables: variables.to_json}, headers: {Authorization: "Bearer token"}
  end

  let(:variables) { {id: client_id} }

  context "when the user is a coach" do
    let(:user) { create(:user, :coach) }
    let(:coach) { user.authenticatable }
    let(:client) { create(:client, coach: coach) }
    let(:client_id) { client.id.to_s }

    before do
      authenticate_user(user)
      execute_get_client_info_query
    end

    it "returns the client's information" do
      client_data = response.parsed_body.dig("data", "client")
      expect(client_data["id"]).to eq(client.id.to_s)
      expect(client_data["name"]).to eq(client.name)
      expect(client_data["surname"]).to eq(client.surname)
    end
  end

  context "when the user is not a coach" do
    let(:user) { create(:user, :client) }
    let(:client_id) { "some_client_id" }

    before do
      authenticate_user(user)
      execute_get_client_info_query
    end

    it "returns an authorization error" do
      expect(response.parsed_body.dig("errors").first.dig("message"))
        .to eq("Authorization error: this user is not allowed to see_coach_clients?")
    end
  end

  context "when the client does not exist" do
    let(:user) { create(:user, :coach) }
    let(:coach) { user.authenticatable }
    let(:client_id) { "non_existent_id" }

    before do
      authenticate_user(user)
      execute_get_client_info_query
    end

    it "returns a not found error" do
      expect(response.parsed_body.dig("errors").first.dig("message"))
        .to match(/Couldn't find Client with 'id'=non_existent_id/)
    end
  end

  let(:query) do
    <<~GQL
      query($id: String!) {
        client(id: $id) {
          id
          name
          surname
        }
      }
    GQL
  end
end
