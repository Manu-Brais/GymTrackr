require "rails_helper"
RSpec.describe "GraphQL, signUp mutation", type: :request do
  let(:query) do
    <<~QUERY
      mutation signup(
        $email: String!,
        $type: String!
        $name: String!
        $surname: String!
        $phone: String!
        $address: String!
        $password: String!,
        $password_confirmation: String!,
        ) {
        signup(
          input: {
            name: $name,
            surname: $surname,
            phone: $phone,
            address: $address,
            type: $type,
            email: $email,
            password: $password,
            passwordConfirmation: $password_confirmation,
          }
        ) {
          user {
            email
          }
          errors
        }
      }
    QUERY
  end

  it "signs up a new user successfully" do
    post "/graphql", params: {
      query: query,
      variables: {
        name: "Antonio",
        surname: "Martinez",
        phone: "987654321",
        address: "C/ Milladoiro",
        type: "pepe",
        email: "pepe21@gmail.com",
        password: "password",
        passwordConfirmation: "password"
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
