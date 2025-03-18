FactoryBot.define do
  factory :user do
    nickname {Faker::Name.name}
    sequence(:email) {|n| "user-#{n}@example.com"}
    password {"password"}
  end
end