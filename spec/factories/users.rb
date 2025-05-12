# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    nickname { Faker::Name.name }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

  trait :longname do
    nickname { 'a' * 61 }
  end

  trait :longemail do
    email { "#{'a' * 243}@example.com" }
  end
end
