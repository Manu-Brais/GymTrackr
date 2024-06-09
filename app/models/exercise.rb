class Exercise < ApplicationRecord
  has_one_attached :video
  has_one :coach

  validates :title, presence: true
  validates :video, presence: true
  validates :video_status, inclusion: {in: %w[enqueued processing processed failed]}

  enum video_status: {
    enqueued: "enqueued",
    processing: "processing",
    processed: "processed",
    failed: "failed"
  }
end
