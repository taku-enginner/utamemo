# frozen_string_literal: true

class AddForeignKeyToMemo < ActiveRecord::Migration[7.2]
  def change
    add_reference :memos, :artist, null: false, foreign_key: true, default: 1
    add_reference :memos, :song, null: false, foreign_key: true, default: 1
  end
end
