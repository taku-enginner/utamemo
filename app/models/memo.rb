class Memo < ApplicationRecord
  belongs_to :user
  validates :artist_name, presence: true
  validates :song_title, presence: true
end
