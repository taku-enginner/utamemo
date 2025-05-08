# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe "バリデーションチェック" do
    it "アーティストの登録が成功する" do
      artist = FactoryBot.build(:artist)
      expect(artist).to be_valid
    end
  end
end
