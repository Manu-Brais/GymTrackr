class Exercise < ApplicationRecord
  after_destroy_commit { video.attachment.purge }

  has_one_attached :video, dependent: :purge
  belongs_to :coach

  validates :title, presence: true
  validates :video_status, inclusion: {in: %w[initialized enqueued processing processed failed]}

  enum video_status: {
    initialized: "initialized",
    enqueued: "enqueued",
    processing: "processing",
    processed: "processed",
    failed: "failed"
  }
end
