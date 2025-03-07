# frozen_string_literal: true

class MypageController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @my_memos = current_user.memos.order(created_at: :desc)
  end
end
