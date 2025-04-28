# frozen_string_literal: true

FactoryBot.define do
  factory :memo do
    artist_name { Faker::Music::GratefulDead.player }
    song_title { Faker::Music::GratefulDead.song }
  end
end