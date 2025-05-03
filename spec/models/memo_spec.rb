# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Memo do
  describe 'バリデーションチェック' do
    let(:user) { create(:user) }
    context '正常系' do
      it '設定したすべてのバリデーションが機能している' do
        memo = FactoryBot.build(:memo, user_id: user.id)
        expect(memo).to be_valid
        expect(memo.errors).to be_empty
      end
    end

    context '異常系' do
      it '曲名が空欄' do
        memo = FactoryBot.build(:memo, song_title: nil, user_id: user.id)
        expect(memo).to be_invalid
      end

      it 'アーティスト名が空欄' do
        memo = FactoryBot.build(:memo, artist_name: nil, user_id: user.id)
        expect(memo).to be_invalid
      end
    end
  end
end
