# frozen_string_literal: true

class ChangeDatatypeNameOfArtists < ActiveRecord::Migration[7.2]
  def change
    change_column :artists, :name, :string, limit: 60
  end
end
