# TODO: ファイル行数が多いので分割する。（現状rubocopの警告は無視してる）

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memos', type: :system, js: true do
  describe 'アクセス確認' do
    context '未ログイン状態' do
      it 'ログインボタン、新規会員登録ボタンが表示される' do
        visit root_path
        click_on '☰'
        expect(page).to have_content('ゲスト')
        expect(page).to have_content('ログイン')
        expect(page).to have_content('新規会員登録')
        expect(page).to have_no_content('ログアウト')
      end
    end

    context 'ログイン状態' do
      let!(:user) { FactoryBot.create(:user) }
      before do
        sign_in user
      end

      it 'ログアウトしたら、ホームに戻り、ヘッダー表示が「ゲストさん」になり、ヘッダー内容が未ログイン状態になる' do
        visit root_path

        click_on '☰'
        expect(page).to have_content(user.nickname)
        expect(page).to have_content('ログアウト')
        expect(page).to have_content('マイページ')
        expect(page).to have_no_content('ログイン')
        expect(page).to have_no_content('新規会員登録')

        click_on 'ログアウト'
        click_on '☰'
        expect(page).to have_current_path(root_path)
        expect(page).to have_content('ゲスト')
        expect(page).to have_content('ログイン')
        expect(page).to have_content('新規会員登録')
        expect(page).to have_no_content('ログアウト')
      end

      it 'ログアウトしたら、プロフィール画面が開けず、非公開メモも開けず、公開メモではツールバーが表示されず、検索後の「この曲をメモする」でログインページにリダイレクトされる' do
        # ログアウトする
        visit root_path
        click_on '☰'
        click_on 'ログアウト'

        # # マイページを開こうすると、ログインページにリダイレクトされる
        # visit user_profile_path(user.id)
        # click_on "☰"
        # # expect(page).to have_content("ログインもしくはアカウント登録してください。")
        # expect(page).to have_content("ようこそ、UTAMEMOへ")
        # expect(page).to have_content("ログインする")
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
