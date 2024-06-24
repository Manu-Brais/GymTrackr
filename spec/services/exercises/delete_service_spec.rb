require "spec_helper"

RSpec.describe Exercises::DeleteService do
  subject(:service) { described_class.call(coach.id, exercise.id) }

  let(:coach) { create(:coach) }
  let(:exercise) { create(:exercise, coach: coach) }

  describe "#call" do
    context "when exercise is successfully deleted" do
      it "returns Success(true)" do
        result = service

        expect(result).to be_success
        expect(result.success).to be true
        expect { Exercise.find(exercise.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when exercise does not exist" do
      let(:nonexistent_id) { 0 }
      subject(:service) { described_class.call(coach.id, nonexistent_id) }

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure.message).to include("Couldn't find Exercise")
      end
    end

    context "when exercise belongs to another coach" do
      let(:another_coach) { create(:coach) }
      subject(:service) { described_class.call(another_coach.id, exercise.id) }

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure.message).to include("Couldn't find Exercise")
      end
    end

    context "when exercise deletion fails" do
      before do
        allow(Coach).to receive(:find).and_return(coach)
        allow(coach.exercises).to receive(:find).and_return(exercise)
        allow(exercise).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed, exercise)
        exercise.errors.add(:base, "Failed to destroy the record")
      end

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to include("Error deleting exercise #{exercise.id}")
      end
    end
  end
end
