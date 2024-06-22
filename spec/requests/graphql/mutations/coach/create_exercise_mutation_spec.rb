require "spec_helper"

RSpec.describe "GraphQL, CreateExercise mutation", type: :request do
  subject(:execute_create_exercise_mutation) do
    post "/graphql", params: params, headers: headers
  end

  let(:headers) do
    {
      "Authorization" => "Bearer token",
      "Content-Type" => "multipart/form-data"
    }
  end

  let(:title) { "Exercise title" }
  let(:description) { "Exercise description" }
  let(:video_file) { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", "sample_video.mp4"), "video/mp4") }

  let(:operations) do
    {
      query: mutation,
      variables: {
        title: title,
        description: description,
        videoFile: nil
      }
    }
  end

  let(:map) do
    {
      "0" => ["variables.videoFile"]
    }
  end

  let(:params) do
    {
      :operations => operations.to_json,
      :map => map.to_json,
      "0" => video_file
    }
  end

  context "when the user is a coach" do
    let(:user) { create(:user, :coach) }
    let(:coach) { user.authenticatable }

    before do
      authenticate_user(user)
      execute_create_exercise_mutation
    end

    it "creates a new exercise and enqueue the video" do
      exercise = response.parsed_body.dig("data", "createExercise", "exercise")
      expect(exercise.fetch("title")).to eq(title)
      expect(exercise.fetch("description")).to eq(description)
      expect(exercise.fetch("videoStatus")).to eq("enqueued")
    end
  end

  context "when the user is a client" do
    let(:user) { create(:user, :client) }

    before do
      authenticate_user(user)
      execute_create_exercise_mutation
    end

    it "returns an authorization error" do
      expect(response.parsed_body.dig("errors").first.dig("message"))
        .to eq("Authorization error: this user is not allowed to create_exercise?")
    end
  end

  def mutation
    <<~GQL
      mutation CreateExercise($title: String!, $description: String!, $videoFile: Upload!) {
        createExercise(
          input: {
            title: $title,
            description: $description,
            videoFile: $videoFile
          }) {
            exercise {
              title
              description
              videoStatus
              videoUrl
            }
          }
      }
    GQL
  end
end
