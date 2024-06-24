require "spec_helper"

RSpec.describe Exercises::UpdateService do
  subject(:service) { described_class.call(coach.id, exercise.id, title, description, video_file) }

  let(:coach) { create(:coach) }
  let(:exercise) { create(:exercise, coach: coach) }
  let(:title) { "Updated Exercise Title" }
  let(:description) { "Updated Exercise Description" }
  let(:video_file) { double(:video_file, original_filename: "updated_video.mp4", read: "video content") }

  describe "#call" do
    context "when all steps succeed" do
      before do
        allow(File).to receive(:binwrite)
        allow(ExercisesProcessingJob).to receive(:perform_later)
      end

      it "returns the exercise in state :enqueued" do
        result = service

        expect(result).to be_success
        expect(result.success).to have_attributes(
          id: exercise.id,
          title: title,
          description: description,
          video_status: "enqueued"
        )
      end
    end

    context "when exercise is not found" do
      let(:coach_with_no_exercises) { create(:coach) }
      subject(:service) { described_class.call(coach_with_no_exercises.id, exercise.id, title, description, video_file) }

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure.message).to include("Couldn't find Exercise with 'id'")
      end
    end

    context "when exercise update fails" do
      let(:title) { nil }
      let(:description) { nil }

      before do
        allow_any_instance_of(Exercise).to receive(:update!).and_raise(ActiveRecord::RecordInvalid, exercise)
        exercise.errors.add(:title, "There was an error")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("Title There was an error")
      end
    end

    context "when video file saving fails" do
      before do
        allow(File).to receive(:binwrite).and_raise(Errno::ENOENT)
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure.message).to include("No such file or directory")
      end
    end
  end
end
