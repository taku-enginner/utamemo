# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profilesコントローラーのテスト', type: :request do
  let(:user) { create(:user) }
  describe 'ログイン済み' do
    before do
      sign_in user
    end
    context 'マイページが正しく表示される' do
      before do
        get user_profile_path(user.id)
      end
      it 'リクエストは200 OKとなること' do
        expect(response).to have_http_status(200)
      end
      it '「マイページ」を含んでいること' do
        expect(response.body).to include 'マイページ'
      end
    end

    context "プロフィール編集ページが正しく表示される" do
      before do
        get edit_user_profile_path(user.id)
      end
      it "リクエストは200 OKとなること" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '非ログイン' do
    context 'マイページへ遷移されない' do
      before do
        get user_profile_path(user.id)
      end
      it 'ログインページが表示されること' do
        # リクエストスペックではcurrent_pathは使えない。current_pathはcapybaraの機能。
        # 代わりにresponse.locationを使う。response.locationはリダイレクト先のURLを返す。通常のgetではこの値はnilになる。
        expect(response.location).to include new_user_session_path
      end
    end
  end
end