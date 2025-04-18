# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_memo, only: %i[show update destroy]

  def index
    @memos = Memo.includes(:user).where(publish: true).order(updated_at: :desc).page(params[:page]).per(5)
  end

  def show
    request.format = :html # turboを無効化

    # メモが非公開でログインユーザーとメモ所有者が違うなら新着メモ一覧に飛ばす
    # メモが非公開でゲストユーザーなら新着メモ一覧に飛ばす
    if access_denied?
      flash[:alert] = t('alerts.memo_not_publish')
      redirect_to memos_path
    end

    # メモが外部公開していれば表示。していなければ所有者のメモなら表示、違うなら一覧に戻してフラッシュメッセージを表示。
    api_key = Rails.application.credentials[:musixmatch_api_key]

    # turbo framesからのリクエストだったらパーシャルを返す。パーシャルはid=lyricsのturbo-framesタグに入る
    if turbo_frame_request?
      render partial: 'memos/lyrics', locals: {
        lyrics_result: fetch_lyrics(api_key, @memo[:song_title], @memo[:artist_name])
      }
    else
      # turbo frames空のリクエストでなければ、通常のshowテンプレートを返す
      render :show
    end
  end

  def create
    @memo = Memo.new(memo_params)
    @memo.user_id = current_user.id
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

  def fetch_lyrics(api_key, q_track, q_artist)
    lyrics_encoded_uri = URI::DEFAULT_PARSER.escape("https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=#{api_key}&q_track=#{q_track}&q_artist=#{q_artist}")
    lyrics_response = HTTParty.get(lyrics_encoded_uri)
    lyrics_response_code_check = JSON.parse(lyrics_response)
    Rails.logger.debug { "lyrics_response: #{JSON.pretty_generate(lyrics_response_code_check)}" }
    return nil if lyrics_response_code_check['message']['header']['status_code'] == 404

    parsed_json_lyrics_response = JSON.parse(lyrics_response)
    parsed_json_lyrics_response['message']['body']['lyrics']['lyrics_body']
  end

  def set_memo
    @memo = Memo.find_by(id: params[:id])
  end

  def access_denied?
    return true if (!@memo.publish && current_user.id != @memo.user_id) || (current_user.nil? && !@memo.publish)

    false
  end
end
