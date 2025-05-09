# frozen_string_literal: true

class RenameMemoTitleColumnToMemos < ActiveRecord::Migration[7.2]
  def change
    rename_column :memos, :memo_title, :title
  end
end
