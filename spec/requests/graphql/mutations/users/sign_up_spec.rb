require "rails_helper"
RSpec.describe "GraphQL, signUp mutation", type: :request do
  context "happy path" do
    context "when the user is a coach" do
      it "signs up a new coach successfully" do
        post "/graphql", params: { query: query_string, variables: variables }, headers: headers
      end
    end

    context "when the user is a client" do
      it "signs up a new client successfully"
    end
  end

  context "unhappy path" do
    context "when the user is a coach" do
      context "when the email is already taken"
      context "when the password is too short"
      context "when the password confirmation does not match the password"
    end
    context "when the user is a client" do
      context "when the email is already taken"
      context "when the password is too short"
      context "when the password confirmation does not match the password"
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
            }
            errors
        }
      }
    GQL
  end
end
