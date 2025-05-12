# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PracticeLog, type: :model do
  describe 'バリデーションチェック' do
    context '正常系' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:practice_log) { FactoryBot.build(:practice_log) }

      it '正常に登録ができる' do
        practice_log.user_id = user.id
        expect(practice_log).to be_valid
      end
    end

    context '異常系' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:practice_log) { FactoryBot.build(:practice_log) }

      it 'ユーザーidの情報が無ければエラーになる' do
        expect(practice_log).to be_invalid
      end

      it 'タイトルがnilだとエラーになる' do
        practice_log.song = nil
        expect(practice_log).to be_invalid
      end

      it 'placeholder_memoが501文字以上だとエラー' do
        practice_log.placeholder_memo = 'a' * 501
        expect(practice_log).to be_invalid
      end

      it 'commentが501文字以上だとエラー' do
        practice_log.comment = 'a' * 501
        expect(practice_log).to be_invalid
      end
    end
  end
end
