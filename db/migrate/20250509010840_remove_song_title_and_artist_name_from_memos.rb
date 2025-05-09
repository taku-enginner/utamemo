# frozen_string_literal: true

class RemoveSongTitleAndArtistNameFromMemos < ActiveRecord::Migration[7.2]
  # ロールバック時にリカバリ出来るようにupとdownで記載
  def up
    change_table :memos, bulk: true do |t|
      t.remove :artist_name
      t.remove :song_title
    end
  end

  def down
    change_table :memos, bulk: true do |t|
      t.string :artist_name
      t.string :song_title
    end
  end
end
