FactoryBot.define do
  factory :user do
    email { "test@email.com" }
    password { "password" }
    authenticatable { create(:coach) }

    trait :coach do
      authenticatable { create(:coach) }
    end

    trait :client do
      authenticatable { create(:client) }
    end
  end
end
