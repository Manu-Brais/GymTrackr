class Exercise < ApplicationRecord
  has_one_attached :video

  validates :name, presence: true
  validates :video_url, presence: true
  validates :video_status, inclusion: {in: %w[enqueued processing processed failed]}

  enum video_status: {
    in_process: "enqueued",
    processing: "processing",
    processed: "processed",
    failed: "failed"
  }
end
