# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session', type: :request do
  # describe 'GET /sessions_new' do
  #   context '未登録の状態' do
  #     it 'ログインに失敗する' do
  #       user = User.build(nickname: 'hogehoge', email: 'hoge@example.com', password: 'hogehoge',
  #                         password_confirmation: 'hogehoge')
  #       post user_session_path, params: {
  #         user: {
  #           email: user.email,
  #           password: user.password
  #         }
  #       }
  #       expect(response).to have_http_status(422)
  #     end

  #     # registration_specで書くべき
  #     it '登録に成功する' do
  #       user = User.build(nickname: 'hogehoge', email: 'hoge@example.com', password: 'hogehoge',
  #                         password_confirmation: 'hogehoge')
  #       post user_registration_path, params: {
  #         user: {
  #           email: user.email,
  #           password: user.password
  #         }
  #       }
  #       expect(response).to have_http_status(303)
  #     end

  #     # registration_specで書くべき
  #     # it '登録に失敗する' do
  #     # end
  #   end

  #   context '登録済みの状態' do
  #     it 'ログインに成功する' do
  #       user = User.create(nickname: 'hogehoge', email: 'hoge@example.com', password: 'hogehoge',
  #                          password_confirmation: 'hogehoge')
  #       post user_session_path, params: {
  #         user: {
  #           email: user.email,
  #           password: user.password
  #         }
  #       }
  #       expect(response).to have_http_status(303)
  #     end

  #     it '登録されていないデータなら、ログインに失敗する' do
  #       FactoryBot.create(:user)
  #       user2 = User.build(nickname: 'hogehoge', email: 'hoge@example.com', password: 'hogehoge',
  #                          password_confirmation: 'hogehoge')
  #       post user_session_path, params: {
  #         user: {
  #           email: user2.email,
  #           password: user2.password
  #         }
  #       }
  #       expect(response).to have_http_status(422)
  #     end
  #   end
  # end
end
