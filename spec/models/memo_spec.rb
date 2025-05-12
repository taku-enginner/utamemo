# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Memo do
  describe 'バリデーションチェック' do
    let(:user) { FactoryBot.create(:user) }

    context '正常系' do
      it '設定したすべてのバリデーションが機能している' do
        artist = FactoryBot.create(:artist)
        song = FactoryBot.create(:song, artist_id: artist.id)

        memo = FactoryBot.build(:memo, artist_id: artist.id, song_id: song.id, user_id: user.id)
        expect(memo).to be_valid
        expect(memo.errors).to be_empty
      end
    end

    context '異常系' do
      it 'タイトルが61文字以上' do
        artist = FactoryBot.create(:artist)
        song = FactoryBot.create(:song, artist_id: artist.id)

        memo = FactoryBot.build(:memo, artist_id: artist.id, song_id: song.id, user_id: user.id)
        memo.title = 'a' * 61
        expect(memo).to be_invalid
      end
    end
  end
end
