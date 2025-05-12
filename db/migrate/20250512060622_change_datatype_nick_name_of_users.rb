class ChangeDatatypeNickNameOfUsers < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :nickname, :string, limit: 60
    change_column :users, :email, :string, limit: 254
  end
end
