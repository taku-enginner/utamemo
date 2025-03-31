# frozen_string_literal: true

class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.bigint :user_id
      t.bigint :memo_id

      t.timestamps
    end
  end
end
