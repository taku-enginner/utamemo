class ChangeDatatypeTitleOfMemos < ActiveRecord::Migration[7.2]
  def change
    change_column :memos, :title, :string, limit: 60
  end
end
