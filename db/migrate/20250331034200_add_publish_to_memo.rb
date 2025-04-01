# frozen_string_literal: true

class AddPublishToMemo < ActiveRecord::Migration[7.2]
  def change
    add_column :memos, :publish, :boolean, default: true, null: false
  end
end
