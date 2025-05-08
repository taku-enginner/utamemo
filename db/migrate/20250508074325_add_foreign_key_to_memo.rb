class AddForeignKeyToMemo < ActiveRecord::Migration[7.2]
  def change
    add_reference :memos, :artist, null: false, foreign_key: true, default: 0
    add_reference :memos, :song, null: false, foreign_key: true, default: 0
  end
end
