require "rails_helper"

RSpec.describe "topコントローラーのテスト", type: :request do
  it "トップページが正しく表示される" do 
    get root_path
    expect(response.body).to include "自分だけの歌い方を楽しもう！"
  end

  it "ヘルプページが正しく表示される" do
    get help_path
    expect(response.body).to include "メモを見てみよう！"
  end
end