class CreatePracticeLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :practice_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :memo,  foreign_key: true
      t.string :song
      t.text :placeholder_memo
      t.integer :practice_amount
      t.integer :mood
      t.text :comment

      t.timestamps
    end
  end
end
