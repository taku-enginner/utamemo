# frozen_string_literal: true

class Profile < ApplicationRecord
  has_one_attached :image
  belongs_to :user
end
