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
  end
end
