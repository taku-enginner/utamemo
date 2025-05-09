namespace :memo do
  desc "既存のmemosテーブルからartistsテーブルとsongsテーブルにデータを移行し、外部キーを設定する"
  task migrate_artist_and_song_data: :environment do
    puts "memosテーブルのデータの移行開始"

    unknown_artist = Artist.find_or_create_by(name: "Unknown") rescue Artist.find_by(name: "Unknown")
    unknown_song   = Song.find_or_create_by(title: "Unknown", artist_id: unknown_artist.id) rescue Song.find_by(title: "Unknown", artist_id: unknown_artist.id)
    

    Memo.find_each do |memo|
      # id=1はデフォルトのid。デフォルトidを持つレコードが移行対象。
      next unless memo.artist_id == 1 || memo.song_id == 1

      p memo.artist_name
      p memo.song_title

      artist = Artist.find_or_create_by!(name: memo.artist_name)
      p artist.id
      song = Song.find_or_create_by!(title: memo.song_title, artist_id: artist.id)

      memo.artist_id = artist.id
      memo.song_id = song.id

      if memo.save(validate: false)
        puts "memo id = #{memo.id}　→ artist_id = #{artist.id}, song_id = #{song.id} を設定"
      else
        puts "失敗: memo id = #{memo.id}, #{memo.errors.full_messages.join(",")}"
      end
    end

    puts "データ移行完了！"
  end
end