FactoryBot.define do
  factory :exercise do
    title { "Exercise Title" }
    description { "Exercise Description" }
    video_status { "enqueued" }
    coach { create(:coach) }
  end
end
