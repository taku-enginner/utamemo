# frozen_string_literal: true

class Memo < ApplicationRecord
  belongs_to :user
  validates :artist_name, presence: true
  validates :song_title, presence: true
  validates :memo_title, presence: true
end
