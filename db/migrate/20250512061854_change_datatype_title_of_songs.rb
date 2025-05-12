# frozen_string_literal: true

class ChangeDatatypeTitleOfSongs < ActiveRecord::Migration[7.2]
  def change
    change_column :songs, :title, :string, limit: 60
  end
end
