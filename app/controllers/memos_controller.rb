# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]

  def index
    @memos = Memo.includes(:user).order(created_at: :desc)
  end

  def show
    request.format = :html # turboを無効化
    @memo = Memo.find(params[:id])
    api_key = Rails.application.credentials[:musixmatch_api_key]

    # turbo framesからのリクエストだったらパーシャルを返す
    # パーシャルはid=lyricsのturbo-framesタグに入る
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
      render 'musixmatch/search', alert: 'メモの開始に失敗しました。'
    end
  end

  def update
    @memo = Memo.find(params[:id])

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
    @memo = Memo.find_by(id: params[:id])
    if @memo.destroy
      flash[:notice] = t('notices.memo_deleted')
      redirect_to user_profile_path(current_user.id)
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
end
