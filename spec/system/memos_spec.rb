# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memos', type: :system, js: true do
  # jsをテストするときはこれは書かない
  # before do
  #   driven_by(:rack_test)
  # end

  describe 'アクセス確認' do
    context '未ログインの状態' do
      it '新着メモ一覧へのアクセスが成功する' do
        # url直打ち
        visit memos_path
        expect(page).to have_content('新着メモ一覧')

        # UI上の画面遷移
        visit root_path
        click_on "☰" # ハンバーガーメニューの動作確認
        expect(page).to have_content("新着メモ一覧")

        click_on "新着メモ一覧"
        expect(page).to have_content("新着メモ一覧")
      end

      it '新着メモプレビューへのアクセスが成功する' do
        user = FactoryBot.create(:user)
        memo = FactoryBot.create(:memo, user_id: user.id)
        
        # url直打ち
        visit memo_path(memo.id)
        expect(page).to have_content("created_by: #{user.nickname}")

        # UI上の画面遷移
        visit memos_path
        click_on memo.song_title
        expect(page).to have_content("created_by: #{user.nickname}")
        expect(page).not_to have_content("保存")
      end

      it "マイメモ一覧へのアクセスが失敗する" do
        # URL直打ち
        user = FactoryBot.create(:user)
        visit my_memos_user_profile_path(user.id)
        expect(page).to have_content("ログインもしくはアカウント登録してください") #フラッシュメッセージ
        expect(page).to have_content("ようこそ、UTAMEMOへ")
        expect(current_path).to eq new_user_session_path
      end

      it "曲の検索に成功する" do
        # UI上の画面遷移
        visit root_path
        click_on "☰"
        click_on "新規メモ作成🔍"
        expect(page).to have_content("歌詞を検索")

        fill_in "アーティスト名", with: "キタニタツヤ"
        fill_in "曲名", with: "青のすみか"
        click_button "検索"

        expect(page).to have_content("読み込み中")
        expect(page).not_to have_content("読み込み中", wait: 10)

        # 読み込み中が消え、turboでデータが送られてきた後にテスト再開
        expect(page).to have_content("青のすみか", wait: 5)
        expect(page).to have_content("キタニタツヤ")
        expect(page).to have_content("どこまでも続くような青の季節は")
      end

      it "メモの作成で登録失敗する" do
        # UI上の画面遷移
        visit root_path
        click_on "☰"
        click_on "新規メモ作成🔍"
        expect(page).to have_content("歌詞を検索")

        fill_in "アーティスト名", with: "キタニタツヤ"
        fill_in "曲名", with: "青のすみか"
        click_button "検索"

        expect(page).to have_content("読み込み中")
        expect(page).not_to have_content("読み込み中", wait: 10)

        # 読み込み中が消え、turboでデータが送られてきた後にテスト再開
        expect(page).to have_content("青のすみか", wait: 5)
        expect(page).to have_content("キタニタツヤ")
        expect(page).to have_content("どこまでも続くような青の季節は")

        click_on "この曲にメモする"
        expect(page).to have_content("ログインもしくはアカウント登録してください") #フラッシュメッセージ
        expect(page).to have_content("ようこそ、UTAMEMOへ")
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
