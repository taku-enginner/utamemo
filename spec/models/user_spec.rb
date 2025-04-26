# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  context '未登録の状態' do
    it 'ログインに失敗する' do
    end

    it '登録に成功する' do
    end

    it '登録に失敗する' do
    end
  end

  context '登録済みの状態' do
    it 'ログインに成功する' do
    end

    it '登録されていないデータなら、ログインに失敗する' do
    end
  end
end
