# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Song, type: :model do
  let(:artist) { FactoryBot.create(:artist) }
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーションチェック' do
    it '曲の登録が成功する' do
      song = FactoryBot.build(:song, artist_id: artist.id)
      expect(song).to be_valid
    end
  end
end
