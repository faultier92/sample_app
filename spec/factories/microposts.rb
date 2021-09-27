FactoryBot.define do
  factory :micropost do
    sequence(:content) { |n| "MyText#{n}" }
    user { FactoryBot.create(:user) }
  end
end

