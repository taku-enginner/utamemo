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
Rails.logger.debug 'seedファイルの実行がスタートしました'

# ユーザーデータ
3.times do |n|
  email = "testuser#{n + 1}@example.com"
  User.find_or_create_by(email: email) do |u|
    u.email = email
    u.nickname = "テストユーザー#{n + 1}"
    u.password = 'hogehoge'
  end
end

# # アーティストデータ
# 3.times do |n|
#   Artist.find_or_create_by(id: n+1) do |a|
#     a.name = "BE:FIRST"
#   end
# end

# # 曲データ
# 3.times do |n|
#   Song.find_or_create_by(id: n+1) do |s|
#     s.title = "Boom Boom Back"
#     s.artist_id = n
#   end
# end

# メモデータ
User.find_each do |user|
  3.times do |n|
    Memo.find_or_create_by(
      song_title: 'Boom Boom Back',
      artist_name: 'BE:FIRST',
      title: "タイトル#{n + 1}",
      memo_components: [
        {
          id: 1,
          type: 'technique',
          content: '1',
          x: 300,
          y: 500
        },
        {
          id: 2,
          type: 'comment',
          content: '滑らかに',
          x: 300,
          y: 500
        }
      ],
      user_id: user.id,
      artist_id: n+1,
      song_id: n+1
    )
  end
end

Rails.logger.debug 'seedファイルの実行が終了しました'
Rails.logger.debug 'seedファイルの実行が終了しました'
