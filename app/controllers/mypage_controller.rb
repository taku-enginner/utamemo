class MypageController < ApplicationController
  def index
    @my_memos = current_user.memos.order(created_at: :desc)
  end
end
