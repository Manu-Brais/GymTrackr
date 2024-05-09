require "rails_helper"
RSpec.describe "GraphQL, signUp mutation", type: :request do
  let(:query) do
    <<~QUERY
      mutation signup(
        $email: String!,
        $password: String!,
        $password_confirmation: String!,
        $name: String!) {
        signup(
          input: {
            email: $email,
            password: $password,
            passwordConfirmation: $password_confirmation,
            name: $name,
          }
        ) {
          email
          token
        }
      }
    QUERY
  end

  it "signs up a new user successfully" do
    post "/graphql", params: {
      query: query,
      variables: {
        email: "test@example.com",
        password: "SecurePassword1",
        password_confirmation: "SecurePassword1",
        name: "Test User"
      }
    }
    debugger
    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]).to match(
      "signup" => {
        "email" => "test@example.com",
        "token" => be_present
      }
    )
  end
end
