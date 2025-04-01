# frozen_string_literal: true

class Memo < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  validates :artist_name, presence: true
  validates :song_title, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
