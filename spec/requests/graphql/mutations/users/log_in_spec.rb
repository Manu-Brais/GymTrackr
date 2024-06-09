require "spec_helper"

RSpec.describe "GraphQL, logIn mutation", type: :request do
  subject(:execute_log_in_mutation) do
    post "/graphql", params: {
      query: mutation(
        email: email,
        password: password
      )
    }
  end

  let(:email) { "john@doe.com" }
  let(:password) { "password" }

  context "happy path" do
    context "when the login is successfully" do
      before do
        create(:user, :coach, email: email, password: password)
        allow(Authentication::JwtToken::CreateService)
          .to receive(:call).and_return(Success("token"))
        execute_log_in_mutation
      end

      it "returns the token" do
        expect(response.parsed_body.dig("data", "login", "token")).to be_present
      end
    end
  end

  context "unhappy path" do
    context "when the login is not successfully" do
      context "when the email does not exist" do
        before do
          create(:user, :coach, email: "test@gmail.com", password: password)
        end

        it "returns an error" do
          execute_log_in_mutation
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("Log in error: Incorrect email or password")
        end
      end

      context "when the password is incorrect" do
        before do
          create(:user, :coach, email: email, password: "password12345")
        end

        it "returns an error" do
          execute_log_in_mutation
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("Log in error: Incorrect email or password")
        end
      end

      context "when the token generation fails" do
        before do
          create(:user, :coach, email: email, password: password)
          allow(Authentication::JwtToken::CreateService)
            .to receive(:call).and_return(Failure("token error"))
        end

        it "returns an error" do
          execute_log_in_mutation
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("Log in error: token error")
        end
      end
    end
  end

  def mutation(email: nil, password: nil)
    <<~GQL
      mutation {
        login(
          input: {
            email: "#{email || "null"}",
            password: "#{password || "null"}"
          }) {
            token
        }
      }
    GQL
  end
end
