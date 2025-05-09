# frozen_string_literal: true

class CreateSongs < ActiveRecord::Migration[7.2]
  def change
    create_table :songs do |t|
      t.references :artist, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Song.reset_column_information
        Song.create!(title: 'Unknown', artist_id: 1)
      end
    end
  end
end
