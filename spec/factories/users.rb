# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    nickname { Faker::Name.name }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
