require "spec_helper"

RSpec.describe "GraphQL, UpdateUserData mutation", type: :request do
  subject(:execute_update_user_data_mutation) do
    post "/graphql", params: {
                       query: mutation(
                         name: name,
                         surname: surname,
                         phone: phone,
                         address: address
                       )
                     },
      headers: {"Authorization" => "Bearer token"}
  end

  let(:name) { "Jane" }
  let(:surname) { "Doe" }
  let(:phone) { "987654321" }
  let(:address) { "Brentford Street" }

  let(:user) { create(:user, authenticatable: authenticatable) }
  let(:authenticatable_attrs) { {name: "Sergio", surname: "Perez", phone: "123456789", address: "Chelsea Street"} }

  before do
    authenticate_user(user)
    execute_update_user_data_mutation
  end

  context "when the user is a coach" do
    let(:authenticatable) { build(:coach, authenticatable_attrs) }

    it "updates the user data" do
      response_data = response.parsed_body.dig("data", "updateUserData", "userData", "authenticatable")
      expect(response_data.fetch("name")).to eq(name)
      expect(response_data.fetch("surname")).to eq(surname)
      expect(response_data.fetch("phone")).to eq(phone)
      expect(response_data.fetch("address")).to eq(address)
    end
  end

  context "when the user is a client" do
    let(:authenticatable) { build(:client, authenticatable_attrs) }

    it "updates the user data" do
      response_data = response.parsed_body.dig("data", "updateUserData", "userData", "authenticatable")
      expect(response_data.fetch("name")).to eq(name)
      expect(response_data.fetch("surname")).to eq(surname)
      expect(response_data.fetch("phone")).to eq(phone)
      expect(response_data.fetch("address")).to eq(address)
    end
  end

  def mutation(name: nil, surname: nil, phone: nil, address: nil)
    <<~GQL
      mutation {
        updateUserData(
          input: {
            name: "#{name || nil}",
            surname: "#{surname || nil}",
            phone: "#{phone || nil}",
            address: "#{address || nil}",
          }) {
            userData {
              authenticatable {
                ... on Coach {
                id
                name
                surname
                phone
                address
              }
              ... on Client {
                id
                name
                surname
                phone
                address
              }
            }
          }
        }
      }
    GQL
  end
end
