# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PracticeLog, type: :model do
  describe 'バリデーションチェック' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:practice_log) { FactoryBot.build(:practice_log, user_id: user.id) }

    it '正常に登録ができる' do
      expect(practice_log).to be_valid
    end

    it 'ユーザーidの情報が無ければエラーになる' do
      practice_log.user_id = nil
      expect(practice_log).to be_invalid
    end

    it 'タイトルがnilだとエラーになる' do
      practice_log.song = nil
      expect(practice_log).to be_invalid
    end
  end
end
