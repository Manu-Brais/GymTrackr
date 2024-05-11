require "spec_helper"

RSpec.describe "GraphQL, signUp mutation", type: :request do

  subject(:execute_sign_up_mutation) do
    post "/graphql", params: {
      query: mutation(
        name: name,
        surname: surname,
        phone: phone,
        address: address,
        type: type,
        email: email,
        password: password,
        password_confirmation: password_confirmation)
      }
  end

  let(:name) { "John" }
  let(:surname) { "Doe" }
  let(:phone) { "123456789" }
  let(:address) { "1234 Main St" }
  let(:type) { "coach" }
  let(:email) { "john@doe.com" }
  let(:password) { "password" }
  let(:password_confirmation) { "password" }

  context "happy path" do
    before { execute_sign_up_mutation }

    context "when the user is a coach" do
      let(:type) { "coach" }

      it "signs up a new coach successfully" do
        expect(response.parsed_body).to eq({
          "data" => {
            "signup" => {
              "user" => {
                "email" => email,
                "authenticatable" => {
                  "name" => name
                }
              }
            }
          }
        })
      end
    end

    context "when the user is a client" do
      let(:type) { "client" }

      it "signs up a new client successfully" do
        expect(response.parsed_body).to eq({
          "data" => {
            "signup" => {
              "user" => {
                "email" => email,
                "authenticatable" => {
                  "name" => name
                }
              }
            }
          }
        })
      end
    end
  end

  context "unhappy path" do
    context "when the user is a coach" do
      let(:type) { "coach" }

      context "when the email is already taken" do
        before do
          create(:user, email: email, password: password, authenticatable: create(:coach))
          execute_sign_up_mutation
        end

        it "returns an error" do
          expect(response.parsed_body).to eq({
            "errors" => [
              {
                "message" => "Sign up error: Email has already been taken",
                "locations" => [{ "line" => 2, "column" => 3 }],
                "path" => ["signup"]
              }
            ],
            "data" => { "signup" => nil }
          })
        end
      end

      context "when the password is too short" do
        let(:password) { "pass" }
        let(:password_confirmation) { "pass" }

        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body).to eq({
            "errors" => [
              {
                "message" => "Sign up error: Password is too short (minimum is 6 characters)",
                "locations" => [{ "line" => 2, "column" => 3 }],
                "path" => ["signup"]
              }
            ],
            "data" => { "signup" => nil }
          })
        end
      end

      context "when the password confirmation does not match the password" do
        let(:password_confirmation) { "password123" }

        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body).to eq({
            "errors" => [
              {
                "message" => "Sign up error: Password confirmation doesn't match Password",
                "locations" => [{ "line" => 2, "column" => 3 }],
                "path" => ["signup"]
              }
            ],
            "data" => { "signup" => nil }
          })
        end
      end
    end

    context "when the user is a client" do
      let(:type) { "client" }

      context "when the email is already taken" do
        before do
          create(:user, email: email, password: password, authenticatable: create(:client))
          execute_sign_up_mutation
        end

        it "returns an error" do
          expect(response.parsed_body).to eq({
            "errors" => [
              {
                "message" => "Sign up error: Email has already been taken",
                "locations" => [{ "line" => 2, "column" => 3 }],
                "path" => ["signup"]
              }
            ],
            "data" => { "signup" => nil }
          })
        end
      end

      context "when the password is too short" do
        let(:password) { "pass" }
        let(:password_confirmation) { "pass" }

        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body).to eq({
            "errors" => [
              {
                "message" => "Sign up error: Password is too short (minimum is 6 characters)",
                "locations" => [{ "line" => 2, "column" => 3 }],
                "path" => ["signup"]
              }
            ],
            "data" => { "signup" => nil }
          })
        end
      end

      context "when the password confirmation does not match the password" do
        let(:password_confirmation) { "password123" }

        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body).to eq({
            "errors" => [
              {
                "message" => "Sign up error: Password confirmation doesn't match Password",
                "locations" => [{ "line" => 2, "column" => 3 }],
                "path" => ["signup"]
              }
            ],
            "data" => { "signup" => nil }
          })
        end
      end
    end
  end

  def mutation(name: nil, surname: nil, phone: nil, address: nil, type: nil, email: nil, password: nil, password_confirmation: nil)
    <<~GQL
      mutation {
        signup(
          input: {
            name: "#{name || "null"}",
            surname: "#{surname || "null"}",
            phone: "#{phone || "null"}",
            address: "#{address || "null"}",
            type: "#{type || "null"}",
            email: "#{email || "null"}",
            password: "#{password || "null"}",
            passwordConfirmation: "#{password_confirmation || "null"}"
          }) {
            user {
              email
              authenticatable {
                ... on Coach {
                  name
                }
                ... on Client {
                  name
                }
              }
           }
        }
      }
    GQL
  end
end
