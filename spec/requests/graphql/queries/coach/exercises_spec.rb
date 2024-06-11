require "spec_helper"

RSpec.describe "GraphQL, exercises Query", type: :request do
  subject(:execute_exercises_query) do
    post "/graphql", params: {query: query}, headers: {Authorization: "Bearer token"}
  end

  context "when the user is not logged in" do
    before do
      execute_exercises_query
    end

    it "returns a message error" do
      expect(response.parsed_body.dig("errors").first.dig("message"))
        .to match(/Authentication error: /)
    end
  end

  context "when the user is logged in" do
    before do
      authenticate_user(user)
    end

    context "when the user is a coach" do
      let(:user) { create(:user, :coach) }

      before do
        create(:exercise, coach: user.authenticatable, video: fixture_file_upload("spec/fixtures/files/sample_video.mp4"))
        allow(Rails.application.routes.url_helpers).to receive(:rails_blob_path).and_return("videoUrl")

        execute_exercises_query
      end

      it "returns the coach data" do
        expect(response.parsed_body.dig("data", "exercises").first.dig("videoUrl")).to eq("videoUrl")
        expect(response.parsed_body.dig("data", "exercises")).to match_array(
          a_hash_including(
            "description" => "Exercise Description",
            "title" => "Exercise Title",
            "videoStatus" => "enqueued"
          )
        )
      end
    end

    context "when the user is a client" do
      let(:user) { create(:user, :client) }

      before do
        execute_exercises_query
      end

      it "returns a message error" do
        expect(response.parsed_body.dig("errors").first.dig("message"))
          .to match(/Authorization error: /)
      end
    end
  end

  def query
    <<~GQL
      query {
        exercises {
          description
          title
          videoStatus
          videoUrl
        }
      }
    GQL
  end
end
