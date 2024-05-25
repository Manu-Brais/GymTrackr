require "spec_helper"

RSpec.describe "GraphQL, signUp mutation", type: :request do
  subject(:execute_sign_up_mutation) do
    post "/graphql", params: {
      query: mutation(
        type: type,
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        referral_token: referral_token
      )
    }
  end

  let(:email) { "john@doe.com" }
  let(:password) { "password" }
  let(:password_confirmation) { "password" }
  let(:referral_token) { nil }

  context "happy path" do
    before do
      allow(Authentication::JwtToken::CreateService)
        .to receive(:call).and_return(Dry::Monads::Result::Success.new("token"))
      execute_sign_up_mutation
    end

    context "when the user is a coach" do
      let(:type) { "coach" }

      it "signs up a new coach successfully" do
        expect(response.parsed_body.dig("data", "signup", "user")).to eq({
          "email" => email
        })
      end

      it "returns the token" do
        expect(response.parsed_body.dig("data", "signup", "token")).to be_present
      end
    end

    context "when the user is a client" do
      let(:coach) { create(:user, :coach, email: "coach@gmail.com") }
      let(:referral) { create(:referral_token, coach: coach.authenticatable) }
      let(:type) { "client" }
      let(:referral_token) { referral.id }

      it "signs up a new client successfully" do
        expect(response.parsed_body.dig("data", "signup", "user")).to eq({
          "email" => email
        })
      end

      it "returns the token" do
        expect(response.parsed_body.dig("data", "signup", "token")).to be_present
      end

      it "assigns the coach to the client" do
        expect(Client.last.coach).to eq(coach.authenticatable)
      end
    end
  end

  context "unhappy path" do
    context "when the user is a coach" do
      let(:type) { "coach" }

      context "when the email is already taken" do
        before do
          create(:user, :coach, email: email, password: password)
          execute_sign_up_mutation
        end

        it "returns an error" do
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("[\"Email has already been taken\"]")
        end
      end

      context "when the password is too short" do
        let(:password) { "pass" }
        let(:password_confirmation) { "pass" }

        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("[\"Password is too short (minimum is 6 characters)\"]")
        end
      end

      context "when the password confirmation does not match the password" do
        let(:password_confirmation) { "password123" }

        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("[\"Password confirmation doesn't match Password\"]")
        end
      end
    end

    context "when the user is a client" do
      let(:type) { "client" }

      context "when the referral token is not present" do
        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("Referral token is required for Client type")
        end
      end

      context "when the referral token is invalid" do
        let(:referral_token) { "invalid" }

        before { execute_sign_up_mutation }

        it "returns an error" do
          expect(response.parsed_body.dig("errors").first.dig("message"))
            .to eq("Invalid referral token")
        end
      end
    end
  end

  def mutation(type: nil, email: nil, password: nil, password_confirmation: nil, referral_token: nil)
    <<~GQL
      mutation {
        signup(
          input: {
            type: "#{type || "null"}",
            email: "#{email || "null"}",
            password: "#{password || "null"}",
            passwordConfirmation: "#{password_confirmation || "null"}",
            referralToken: "#{referral_token}"
          }) {
            token
            user {
              email
           }
        }
      }
    GQL
  end
end
