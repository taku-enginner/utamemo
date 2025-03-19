require "rails_helper"

RSpec.describe "Mypageコントローラーのテスト", type: :request do
  let(:user) {create(:user)}
  describe "ログイン済み" do
    before do
      sign_in user
    end
    context "マイページが正しく表示される" do
      before do
        get mypage_index_path
      end
      it "リクエストは200 OKとなること" do
        expect(response.status).to eq 200
      end
      it "マイページが表示されること" do
        expect(response.body).to include "マイメモ一覧"
      end
    end
  end

  describe "非ログイン" do
    context "マイページへ遷移されない" do
      before do
        get mypage_index_path
      end
      it "ログインページが表示されること" do
        # リクエストスペックではcurrent_pathは使えない。current_pathはcapybaraの機能。
        # 代わりにresponse.locationを使う。response.locationはリダイレクト先のURLを返す。通常のgetではこの値はnilになる。
        expect(response.location).to include new_user_session_path
      end
    end
  end
end