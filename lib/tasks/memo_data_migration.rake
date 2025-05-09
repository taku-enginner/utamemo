# frozen_string_literal: true

# 実行方法
# bundle exec rake memo:migrate_artist_and_song_data

namespace :memo do
  desc '既存のmemosテーブルからartistsテーブルとsongsテーブルにデータを移行し、外部キーを設定する'
  task migrate_artist_and_song_data: :environment do
    Rails.logger.info 'ーーーーーーーーmemosテーブルのデータの移行開始ーーーーーーーー'
    Rails.logger.info "全メモ数：#{Memo.count}"

    Memo.find_each.with_index do |memo, i|
      # id=1はデフォルトのid。デフォルトidを持つレコードが移行対象。
      next unless memo.artist_id == 1 || memo.song_id == 1

      artist = Artist.find_or_create_by!(name: memo.artist_name)
      song = Song.find_or_create_by!(title: memo.song_title, artist_id: artist.id)

      memo.artist_id = artist.id
      memo.song_id = song.id

      Rails.logger.info "ーー#{i + 1}個目のデータ移行ーー"
      if memo.save(validate: false)
        Rails.logger.info "成功：memo id = #{memo.id}　→ artist_id = #{artist.id}, song_id = #{song.id} を設定"
      else
        Rails.logger.info "⚠失敗⚠: memo id = #{memo.id}, #{memo.errors.full_messages.join(',')}"
      end
    end

    Rails.logger.info 'データ移行完了！'
  end
end
