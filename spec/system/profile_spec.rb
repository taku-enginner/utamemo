# TODO: ファイル行数が多いので分割する。（現状rubocopの警告は無視してる）
# rubocop:disable Metrics/BlockLength

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  describe 'アクセス確認' do
    context '未ログイン状態' do
      it 'アクセスができない' do
        # URL直打ち
        visit edit_user_profile_path(user.id)
        expect(page).to have_content('ログインもしくはアカウント登録してください') # フラッシュメッセージ
        expect(page).to have_content('ようこそ、UTAMEMOへ')
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end
    end

    context 'ログイン済み' do
      it 'アクセスできる' do
        # URL直打ち
        sign_in user
        visit edit_user_profile_path(user.id)
        expect(page).to have_content('プロフィール編集')

        # 画面遷移
        sign_in user
        click_on '☰'
        click_on 'マイページ'
        click_on 'プロフィールを編集'
        expect(page).to have_content('プロフィール編集')
      end
    end
  end

  describe 'プロフィール編集' do
    it 'ニックネームだけで更新できる' do
      fill_in_nickname = 'RSpecテストユーザー'

      sign_in user
      visit edit_user_profile_path(user.id)
      fill_in 'ニックネーム', with: fill_in_nickname
      click_on '保存'
      expect(page).to have_content('プロフィールを更新しました。')
      visit user_profile_path(user.id)
      expect(page).to have_content(fill_in_nickname)
    end

    it '画像のアップロードだけ出来る' do
      sign_in user
      visit edit_user_profile_path(user.id)
      attach_file '変更後のプロフィール画像', 'public/default_share.png'
      click_on '保存'
      expect(page).to have_content('プロフィールを更新しました。')
    end

    it 'ニックネームと画像の両方を更新する' do
      sign_in user
      visit edit_user_profile_path(user.id)

      fill_in_nickname = 'RSpecテストユーザー'
      fill_in 'ニックネーム', with: fill_in_nickname
      attach_file '変更後のプロフィール画像', 'public/default_share.png'
      click_on '保存'
      expect(page).to have_content('プロフィールを更新しました。')

      visit user_profile_path(user.id)
      expect(page).to have_content(fill_in_nickname)
    end
  end
end

# rubocop:enable Metrics/BlockLength
