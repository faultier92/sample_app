FactoryBot.define do
  factory :relationship do
    follower_id { FactoryBot.create(:user) }
    followed_id { FactoryBot.create(:user) }
  end
end

