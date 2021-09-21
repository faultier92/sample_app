FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "testuser#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    activated { true }
    activated_at { Time.zone.now }
  end
end

