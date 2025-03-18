require "rails_helper"

RSpec.describe "Top", type: :system do
  it "GET /" do
    visit root_path
    expect(page).to have_text("自分だけの歌い方を楽しもう！")
  end
end