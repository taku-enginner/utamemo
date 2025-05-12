# frozen_string_literal: true

class Song < ApplicationRecord
  has_many :memos, dependent: :destroy
  belongs_to :artist

  validates :title, presence: true, length: { maximum: 60 }
end
