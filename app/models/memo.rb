# frozen_string_literal: true

class Memo < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :practice_logs # rubocop:disable Rails/HasManyOrHasOneDependent
  belongs_to :song
  belongs_to :artist

  # validates :artist_name, presence: true
  # validates :song_title, presence: true
  validates :artist_id, presence: true
  validates :song_id, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
