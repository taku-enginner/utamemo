# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'バリデーションチェック' do
    context '正常系' do
      it '設定したすべてのバリデーションが機能している' do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
    end

    context '異常系' do
      it 'emailが空欄' do
        user = FactoryBot.build(:user, email: '')
        expect(user).to be_invalid
      end

      it 'パスワードが空欄' do
        user = FactoryBot.build(:user, password: '')
        expect(user).to be_invalid
      end
      it 'パスワード確認が空欄' do
        user = FactoryBot.build(:user, password_confirmation: '')
        expect(user).to be_invalid
      end

      it 'emailが既に登録されている' do
        user1 = FactoryBot.create(:user)
        user2 = FactoryBot.build(:user, email: user1.email)
        expect(user2).to be_invalid
      end
    end
  end
end
