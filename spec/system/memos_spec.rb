# TODO: ファイル行数が多いので分割する。（現状rubocopの警告は無視してる）
# rubocop:disable Metrics/BlockLength

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memos', type: :system, js: true do
  # jsをテストするときはこれは書かない
  # before do
  #   driven_by(:rack_test)
  # end

  describe 'アクセス確認' do
    # musixmatch apiへのリクエストをモック化
    before do
      # 歌詞取得のエンドポイントに対するテストレスポンス
      mock_lyrics_fetcher = "どこまでも続くような青の季節は\n四つ並ぶ眼の前を遮るものは何もない\nアスファルト、蝉時雨を反射して\nきみという沈黙が聞こえなくなる\n\nこの日々が色褪せる\n僕と違うきみの匂いを知ってしまっても\n置き忘れてきた永遠の底に\n\n今でも青が棲んでいる\n今でも青は澄んでいる\nどんな祈りも言葉も\n近づけるのに、届かなかった\n\nまるで、静かな恋のような\n...\n\n******* This Lyrics is NOT for Commercial use *******\n(1409625476042)" # rubocop:disable Layout/LineLength

      # callメソッドをモックする
      allow(LyricsFetcher).to receive(:call).and_return(mock_lyrics_fetcher)

      # 曲のメタデータに対するテストレスポンス
      mock_track_fetcher = { 'track_name' => '青のすみか', 'artist_name' => 'キタニタツヤ' }

      # callメソッドをモックする
      allow(TrackFetcher).to receive(:call).and_return(mock_track_fetcher)
    end

    context '未ログインの状態' do
      it '新着メモ一覧へのアクセスが成功する' do
        # url直打ち
        visit memos_path
        expect(page).to have_content('新着メモ一覧', wait: 5)

        # UI上の画面遷移
        visit root_path
        click_on '☰' # ハンバーガーメニューの動作確認
        expect(page).to have_content('新着メモ一覧')

        click_on '新着メモ一覧'
        expect(page).to have_content('新着メモ一覧')
      end

      it '新着メモプレビューへのアクセスが成功する' do
        user = FactoryBot.create(:user)
        artist = FactoryBot.create(:artist)
        song = FactoryBot.create(:song, artist_id: artist.id)
        memo = FactoryBot.create(:memo, artist_id: artist.id, song_id: song.id, user_id: user.id)

        # url直打ち
        visit memo_path(memo.id)
        expect(page).to have_content("created_by: #{user.nickname}")

        # UI上の画面遷移
        visit memos_path
        click_on memo.song.title
        expect(page).to have_content("created_by: #{user.nickname}")
        expect(page).to have_no_content('保存')
      end

      it 'マイメモ一覧へのアクセスが失敗する' do
        # URL直打ち
        user = FactoryBot.create(:user)
        visit my_memos_user_profile_path(user.id)
        expect(page).to have_content('ログインもしくはアカウント登録してください') # フラッシュメッセージ
        expect(page).to have_content('ようこそ、UTAMEMOへ')
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end

      it '曲の検索に成功する' do
        # UI上の画面遷移
        visit root_path
        click_on '☰'
        click_on '新規メモ作成🔍'
        expect(page).to have_content('歌詞を検索')

        fill_in 'アーティスト名', with: 'キタニタツヤ'
        fill_in '曲名', with: '青のすみか'
        click_button '検索'

        # 読み込み中が消え、turboでデータが送られてきた後にテスト再開
        expect(page).to have_content('青のすみか', wait: 5)
        expect(page).to have_content('キタニタツヤ')
        expect(page).to have_content('どこまでも続くような青の季節は')
      end

      it 'メモの作成で登録失敗する' do
        # UI上の画面遷移
        visit root_path
        click_on '☰'
        click_on '新規メモ作成🔍'
        expect(page).to have_content('歌詞を検索')

        fill_in 'アーティスト名', with: 'キタニタツヤ'
        fill_in '曲名', with: '青のすみか'
        click_button '検索'

        # 読み込み中が消え、turboでデータが送られてきた後にテスト再開
        expect(page).to have_content('青のすみか', wait: 5)
        expect(page).to have_content('キタニタツヤ')
        expect(page).to have_content('どこまでも続くような青の季節は')

        click_on 'この曲にメモする'
        expect(page).to have_content('ログインもしくはアカウント登録してください') # フラッシュメッセージ
        expect(page).to have_content('ようこそ、UTAMEMOへ')
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end
    end

    context 'ログイン済' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:artist) { FactoryBot.create(:artist) }
      let!(:song) {FactoryBot.create(:song, artist_id: artist.id) }
      let!(:memo) { FactoryBot.create(:memo, user_id: user.id, artist_id: artist.id, song_id: song.id) }
      before do
        sign_in user
        visit root_path
      end

      it '新着メモ一覧へのアクセスができる' do
        # url直打ち
        visit memos_path
        expect(page).to have_content('新着メモ一覧')

        # UI上の画面遷移
        visit root_path
        click_on '☰' # ハンバーガーメニューの動作確認
        expect(page).to have_content('新着メモ一覧')

        click_on '新着メモ一覧'
        expect(page).to have_content('新着メモ一覧')
      end

      it 'メモ作成画面へのアクセスができる' do
        # 既にあるメモにアクセスしたらツールバーが表示されることを確認

        # url直打ち
        visit memo_path(memo.id)
        expect(page).to have_content('保存')

        # UI上の画面遷移
        visit memos_path
        click_on song.title
        expect(page).to have_content('保存')
      end

      it 'マイメモ一覧へのアクセスができる' do
        # url直打ち
        visit my_memos_user_profile_path(user.id)
        expect(page).to have_content('マイメモ一覧')

        # UI上の画面遷移
        click_on '☰'
        expect(page).to have_content('ログアウト')
        click_on 'マイページ'
        click_on 'マイメモ一覧'
        expect(page).to have_content('マイメモ一覧')
        expect(page).to have_current_path my_memos_user_profile_path(user.id), ignore_query: true
      end

      it '曲の検索に成功する' do
        # UI上の画面遷移
        click_on '☰'
        click_on '新規メモ作成🔍'
        expect(page).to have_content('歌詞を検索')

        fill_in 'アーティスト名', with: 'キタニタツヤ'
        fill_in '曲名', with: '青のすみか'
        click_button '検索'

        # 読み込み中が消え、turboでデータが送られてきた後にテスト再開
        expect(page).to have_content('青のすみか', wait: 10)
        expect(page).to have_content('キタニタツヤ', wait: 10)
        expect(page).to have_content('どこまでも続くような青の季節は', wait: 10)
      end

      it 'メモ作成が開始できる' do
        # UI上の画面遷移
        click_on '☰'
        click_on '新規メモ作成🔍'
        expect(page).to have_content('歌詞を検索')

        fill_in 'アーティスト名', with: 'キタニタツヤ'
        fill_in '曲名', with: '青のすみか'
        click_button '検索'

        # 読み込み中が消え、turboでデータが送られてきた後にテスト再開
        expect(page).to have_content('青のすみか', wait: 10)
        expect(page).to have_content('キタニタツヤ', wait: 10)
        expect(page).to have_content('どこまでも続くような青の季節は', wait: 10)

        # ボタン押下
        click_on 'この曲にメモする'
        expect(page).to have_content("created_by: #{user.nickname}")
        expect(page).to have_content('保存')
      end

      it 'メモ設定編集ページにアクセスできる' do
        # メモ作成画面への遷移
        visit memo_path(memo.id)
        find_by_id('setting-button').click
        expect(page).to have_content('メモの公開設定')
      end

      it 'メモ設定を更新できる' do
        # 公開状態によってアイコンが変わる
        # 最初は公開
        visit my_memos_user_profile_path(user.id)
        expect(page).to have_css('.published')

        # 非公開に設定
        click_on song.title
        find_by_id('setting-button').click
        choose '公開しない'
        fill_in 'メモタイトル', with: 'テストで非公開にしました。'
        click_on '保存'
        expect(page).to have_content('メモの設定を更新しました。')

        visit my_memos_user_profile_path(user.id)
        expect(page).to have_css('.not-published')
        expect(page).to have_content('テストで非公開にしました。')

        # 公開に再設定
        click_on song.title
        find_by_id('setting-button').click
        choose '公開する'
        fill_in 'メモタイトル', with: 'テストで公開に再設定しました。'
        click_on '保存'
        expect(page).to have_content('メモの設定を更新しました。')

        visit my_memos_user_profile_path(user.id)
        expect(page).to have_css('.published')
        expect(page).to have_content('テストで公開に再設定しました。')
      end

      # UIからのシステムスペックはReactのコンポーネントの概念が絡むため難しいと判断。
      # it "メモの保存ができる" do
      #   visit memo_path(memo.id)
      #   p memo
      #   click_on "保存"
      #   expect(page).to have_content("保存しました")
      # end

      # it "ツールバーを切り替えることができる" do

      # end
      it 'メモの削除ができる' do
        visit my_memos_user_profile_path(user.id)
        find('.delete-button').click
        expect(page).to have_no_css('.delete-button')
        expect(page).to have_content('メモを削除しました。')
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
