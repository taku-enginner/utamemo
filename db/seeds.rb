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
p 'seedファイルの実行がスタートしました'

# ユーザーデータ
3.times do |n|
  email = "testuser#{n + 1}@example.com"
  User.find_or_create_by(email: email) do |u|
    u.email = email
    u.nickname = "テストユーザー#{n + 1}"
    u.password = 'hogehoge'
  end
end

# メモデータ
User.all.each do |user|
  3.times do |n|
    Memo.find_or_create_by(
    song_title: "曲名#{n + 1}",
    artist_name: "アーティスト名#{n + 1}",
    memo_title: "メモタイトル#{n + 1}",
    memo_components: [
      {
        "id": 1,
        "type": "technique",
        "content":"1",
        "x": 300,
        "y": 500,
      },
      {
        "id": 2,
        "type": "comment",
        "content":"滑らかに",
        "x": 300,
        "y": 500,
      },
    ],
    user_id: user.id,
    )
  end
end


Rails.logger.debug 'seedファイルの実行が終了しました'
p 'seedファイルの実行が終了しました'
