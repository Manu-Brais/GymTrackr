module Types
  class ExerciseType < BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :video_status, String, null: false
    field :video_url, String, null: true
    field :video_thumbnail_url, String, null: true
  end
end
