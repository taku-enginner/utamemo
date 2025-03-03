# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Rails.logger.debug 'seedファイルの実行がスタートしました'
p "seedファイルの実行がスタートしました"
3.times do |n|
  email = "testuser#{n+1}@example.com"
  user = User.find_or_create_by(email: email) do |u|
    u.email = email
    u.nickname = "テストユーザー#{n+1}"
    u.password = "hogehoge"
  end
end

Rails.logger.debug 'seedファイルの実行が終了しました'
p "seedファイルの実行が終了しました"