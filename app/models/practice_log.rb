# frozen_string_literal: true

class PracticeLog < ApplicationRecord
  belongs_to :user
  belongs_to :memo, optional: true # メモ必須紐づけの解除

  enum :mood, { good: 1, normal: 2, not_great: 3 }

  validates :song, presence: true
end
