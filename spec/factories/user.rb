FactoryBot.define do
  factory :user do
    name  { "testuser1" }
    email { 'test@example.com' }
    password { 'password' }
  end
end
