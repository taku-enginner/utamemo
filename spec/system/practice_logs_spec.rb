# TODO: ファイル行数が多いので分割する。（現状rubocopの警告は無視してる）

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PracticeLogs', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:practice_log) { FactoryBot.build(:practice_log) }
  describe 'アクセス確認' do
    context '未ログイン状態' do
      it '練習ログ一覧にアクセスできない' do
        # URL直打ち
        visit user_practice_logs_path(user.id)
        expect(page).to have_content('ログインもしくはアカウント登録してください') # フラッシュメッセージ
        expect(page).to have_content('ようこそ、UTAMEMOへ')
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end

      it '新規ログ作成画面にアクセスできない' do
        # URL直打ち
        visit new_user_practice_log_path(user.id)
        expect(page).to have_content('ログインもしくはアカウント登録してください') # フラッシュメッセージ
        expect(page).to have_content('ようこそ、UTAMEMOへ')
        expect(page).to have_current_path new_user_session_path, ignore_query: true
      end
    end

    context 'ログイン状態' do
      before do
        sign_in user
        practice_log.user_id = user.id
        practice_log.save
      end
      it '練習ログ一覧にアクセスできる' do
        # URL直打ち
        visit user_practice_logs_path(user.id)
        expect(page).to have_content('練習ログ一覧')
        expect(page).to have_content(practice_log.song)

        # 画面遷移
        visit root_path
        click_on '☰'
        click_on 'マイページ'
        click_on '練習記録'
        expect(page).to have_content('練習ログ一覧')
        expect(page).to have_content(practice_log.song)
      end

      it '新規ログ作成画面にアクセスできる' do
        # URL直打ち
        visit new_user_practice_log_path(user.id)
        expect(page).to have_content('練習ログを記録する')

        # 画面遷移
        visit root_path
        click_on '☰'
        click_on 'マイページ'
        click_on '練習記録'
        click_on '新しい練習ログを作成'
        expect(page).to have_content('練習ログを記録する')
      end
    end
  end
  describe '練習ログCRUD' do
    before do
      sign_in user
    end
    it '正常にログを作成できる' do
      # アクセス
      visit new_user_practice_log_path(user.id)

      # フォーム入力
      fill_in '練習した曲', with: '青のすみか'
      fill_in '今日の練習メモ', with: '高音と裏声の部分が難しかった'
      fill_in '練習時間（分）', with: 5
      find("option[value='good']").select_option
      fill_in '振り返りコメント', with: '高音や裏声の練習をした方がいいかもしれない'

      # 保存
      click_on '保存する'

      expect(page).to have_content('練習ログを作成しました。')
      expect(page).to have_content('青のすみか')
    end

    it '曲名が抜けていたらログ作成できない' do
      # アクセス
      visit new_user_practice_log_path(user.id)

      # フォーム入力
      fill_in '練習した曲', with: ''
      fill_in '今日の練習メモ', with: '高音と裏声の部分が難しかった'
      fill_in '練習時間（分）', with: 5
      find("option[value='good']").select_option
      fill_in '振り返りコメント', with: '高音や裏声の練習をした方がいいかもしれない'

      # 保存
      click_on '保存する'

      expect(page).to have_content('練習ログの作成に失敗しました。')
      expect(page).to have_content('練習ログを記録する')
    end

    it '作成したログを削除できる' do
      practice_log = FactoryBot.create(:practice_log, user_id: user.id)
      visit user_practice_log_path(user.id, practice_log.id)
      click_on '記録を削除'
      expect(page).to have_content('練習ログ一覧')
      expect(page).to have_content('練習ログを削除しました。')
      expect(page).to have_no_content(practice_log.song)
      expect(page).to have_current_path(user_practice_logs_path(user.id))
    end
  end
end

# rubocop:enable Metrics/BlockLength
