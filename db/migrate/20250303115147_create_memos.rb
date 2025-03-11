# frozen_string_literal: true

class CreateMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :memos do |t|
      t.string :song_title
      t.string :artist_name
      t.string :memo_title
      t.jsonb :memo_components, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
