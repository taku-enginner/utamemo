# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_memo, only: %i[show update destroy]
  before_action :set_artist, only: %i[show update destroy]
  before_action :set_song, only: %i[show update destroy]

  def index
    @memos = Memo.includes(:user, :artist, :song).where(publish: true).order(updated_at: :desc).page(params[:page]).per(5)
  end

  def show
    request.format = :html # turboを無効化

    # メモが非公開でログインユーザーとメモ所有者が違うなら新着メモ一覧に飛ばす
    # メモが非公開でゲストユーザーなら新着メモ一覧に飛ばす
    if access_denied?
      flash[:alert] = t('alerts.memo_not_publish')
      redirect_to memos_path
      return
    end

    # メモが外部公開していれば表示。していなければ所有者のメモなら表示、違うなら一覧に戻してフラッシュメッセージを表示。
    api_key = Rails.application.credentials[:musixmatch_api_key]

    # turbo framesからのリクエストだったらパーシャルを返す。パーシャルはid=lyricsのturbo-framesタグに入る
    if turbo_frame_request?
      lyrics_result = LyricsFetcher.call(api_key: api_key, q_track: @song, q_artist: @artist)
      render partial: 'memos/lyrics', locals: {
        lyrics_result: lyrics_result
      }
    else
      # turbo frames空のリクエストでなければ、通常のshowテンプレートを返す
      render :show
    end
  end

  def create
    artist = Artist.find_or_create_by(name: memo_params[:artist_name])
    song = Song.find_or_create_by(title: memo_params[:song_title], artist_id: artist.id)

    @memo = Memo.new(memo_params)
    @memo.user_id = current_user.id
    @memo.artist_id = artist.id
    @memo.song_id = song.id

    if @memo.save
      redirect_to memo_path(id: @memo.id)
    else
      flash[:alert] = t('alerts.memo_save_fail')
      redirect_to memos_path
    end
  end

  def update
    Rails.logger.debug { "update時のパラメータ：#{JSON.pretty_generate(params[:memo_components])}" }
    # 空配列の場合は空配列で更新する
    if params[:memo_components].empty?
      @memo.update(memo_components: [])
      render json: { message: 'update successfully' }, status: :ok
      return
    end

    if @memo.update(memo_components: update_component_params)
      render json: { message: 'update successfully' }, status: :ok
    else
      $stdout.puts "メモ保存時のエラー：#{@memo.errors.full_messages}"
      # Rails.logger.debug("メモ更新時のエラーログ：#{@memo.errors.full_messages}")
      render json: { message: 'update failed' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @memo.destroy
      flash[:notice] = t('notices.memo_deleted')
      redirect_to my_memos_user_profile_path(current_user.id)
    else
      flash.now[:alert] = t('alerts.memo_delete_failed')
      # renderはビューを直接レンダリングするので、ビューのファイル名を使う
      render "users/#{current_user.id}/profile"
    end
  end

  private

  def memo_params
    params.require(:memo).except(:lyrics).permit(:song_title, :artist_name)
  end

  def update_component_params
    params.require(:memo_components)
  end

  def set_memo
    @memo = Memo.find_by(id: params[:id])
  end

  def set_artist
    @artist = @memo.artist.name
  end

  def set_song
    @song = @memo.song.title
  end

  def access_denied?
    return false if @memo.publish # 公開されていればfalse

    current_user.nil? || current_user.id != @memo.user_id
    # 公開されていないかつユーザーがログインしていなければtrue、もしくはログインユーザidとmemoユーザーidが一致しなければtrue、つまりアクセスできない。
  end
end
