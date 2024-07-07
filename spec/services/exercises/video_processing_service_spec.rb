require "spec_helper"

RSpec.describe Exercises::VideoProcessingService do
  subject(:service) { described_class.call(exercise.id, video_path, options) }

  let(:exercise) { create(:exercise, video_status: :initialized) }
  let(:video_path) { Rails.root.join("spec/fixtures/files/sample_video.mp4").to_path }
  let(:options) { {resolution: "10x10", video_bitrate: 1, audio_bitrate: 1, custom: %w[-crf 99]} }

  describe "#call" do
    context "when all steps succeed" do
      before do
        allow(File).to receive(:delete).with(video_path)
        allow(File).to receive(:delete).with("#{Rails.root}/tmp/thumbnail_#{exercise.id}.jpg")
        allow(File).to receive(:delete).with("#{Rails.root}/tmp/output_#{exercise.id}.mp4").and_call_original
      end

      it "returns success with message 'Video processed successfully. 🫡'" do
        result = service
        expect(result).to be_success
        expect(result.success).to eq("Video processed successfully. 🫡")
        expect(exercise.reload.video_status).to eq("processed")
      end
    end

    context "when the exercise does not exist" do
      subject(:service) { described_class.call(nil, video_path, options) }

      it "returns a Failure monad with the error message" do
        expect(service).to be_failure
        expect(service.failure).to be_a(ActiveRecord::RecordNotFound)
      end
    end

    context "when the video is already processed" do
      before do
        exercise.update!(video_status: :processed)
      end

      it "returns a Failure monad with the error message" do
        result = service
        expect(result).to be_failure
        expect(result.failure).to eq("Video already processed.")
      end
    end

    context "when video processing fails" do
      let(:ffmpeg_movie) { double(transcode: false) }

      before do
        allow(FFMPEG::Movie).to receive(:new).and_return(ffmpeg_movie)
        allow(ffmpeg_movie).to receive(:transcode).and_raise(FFMPEG::Error, "transcode error")
      end

      it "returns a Failure monad with the error message" do
        result = service
        expect(result).to be_failure
        expect(result.failure).to be_a(FFMPEG::Error)
        expect(exercise.reload.video_status).to eq("failed")
      end
    end
  end
end
