require 'rails_helper'

RSpec.describe "Memos", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "アクセス確認" do
    context "未ログインの状態" do
      it "新着メモ一覧へのアクセスが成功する" do
        visit memos_path
        expect(page).to have_content("新着メモ一覧")
      end

      it "新着メモプレビューへのアクセスが成功する" do
        user = FactoryBot.create(:user)
        memo = FactoryBot.create(:memo, user_id: user.id)
        visit memos_path
        click_on memo.song_title
        expect(page).to have_content("created_by: #{user.nickname}")
      end
    end
  end
end
