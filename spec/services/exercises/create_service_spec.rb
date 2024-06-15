require "spec_helper"

RSpec.describe Exercises::CreateService do
  subject(:service) { described_class.call(coach_id, title, description, video_file) }

  let(:coach) { create(:coach) }

  let(:coach_id) { coach.id }
  let(:title) { "Exercise title" }
  let(:description) { "Exercise description" }
  let(:video_file) { double(:video_file, original_filename: "video.mp4", read: "video content") }

  describe "#call" do
    context "when all steps succeed" do
      before do
        allow(File).to receive(:binwrite)
        allow(ExercisesProcessingJob).to receive(:perform_later)
      end

      it "returns the exercise in state :enqueued" do
        expect(service.success).to be_a(Exercise)
        expect(service.success).to have_attributes(
          coach_id: coach_id,
          title: title,
          description: description,
          video_status: "enqueued"
        )
      end
    end

    context "when exercise creation fails" do
      let(:coach_id) { nil }

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("Coach must exist")
      end
    end

    context "when video file saving fails" do
      before do
        allow(Exercise).to receive(:create).and_return(Exercise.new(id: 1))
        allow(File).to receive(:binwrite).and_raise(Errno::ENOENT)
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure.message).to include("No such file or directory")
      end
    end

    context "when exercise update fails" do
      let(:exercise) { create(:exercise) }

      before do
        exercise.errors.add(:video_status, "not in the list of allowed values")
        allow(Exercise).to receive(:create!).and_return(exercise)
        allow(File).to receive(:binwrite)
        allow(ExercisesProcessingJob).to receive(:perform_later)
        allow(exercise).to receive(:update!).and_raise(ActiveRecord::RecordInvalid, exercise)
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure.message).to include("Video status not in the list of allowed values")
      end
    end
  end
end
