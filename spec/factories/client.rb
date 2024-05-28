FactoryBot.define do
  factory :client do
    name { "John" }
    surname { "Doe" }
    phone { "654321234" }
    address { "1234 Main St" }
    coach { create(:coach) }
  end
end
