# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Memosコントローラーのテスト', type: :request do
  it 'メモ一覧ページが表示される' do
    get memos_path
    expect(response.body).to include '新着メモ一覧'
  end
  # let(:user) {create(:user)}
  # describe "ログイン済み" do
  #   before do
  #     sign_in user
  #   end
  # end
end
