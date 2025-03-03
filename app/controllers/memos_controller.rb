class MemosController < ApplicationController
  before_action :authenticate_user!, only: %i(create update destroy)

  def index
  end

  def show
    @memo = Memo.find(params[:id])
  end

  def create
    p "createメソッドが呼ばれました"
    p "memo_params: #{memo_params}"
    @memo = Memo.new(memo_params)
    @memo.user_id = current_user.id
    if @memo.save
      redirect_to memo_path(@memo.id)
    else
      render "musixmatch/search", alert: "メモの開始に失敗しました。"
    end
  end

  def update
  end

  def destroy
  end

  private

  def memo_params
    params.require(:memo).permit(:song_title, :artist_name)
  end
end
