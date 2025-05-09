# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :songs, dependent: :destroy
  has_many :memos, dependent: :destroy
  validates :name, presence: true
end
