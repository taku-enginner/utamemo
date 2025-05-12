# frozen_string_literal: true

class ChangeDatatypePlaceholderMemoCommentOfPracticeLogs < ActiveRecord::Migration[7.2]
  def change
    change_column :practice_logs, :placeholder_memo, :string, limit: 500
    change_column :practice_logs, :comment, :string, limit: 500
  end
end
