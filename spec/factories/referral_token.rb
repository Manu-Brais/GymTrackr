FactoryBot.define do
  factory :referral_token do
    coach { create(:coach) }
  end
end
