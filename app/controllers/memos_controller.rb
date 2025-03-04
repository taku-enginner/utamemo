# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]

  def index; end

  def show
    # @memo = Memo.find(params[:id])
    @memo = Memo.first

    api_key = Rails.application.credentials[:musixmatch_api_key]
    title = @memo[:song_title]
    artist_name = @memo[:artist_name]
    @lyrics_result = fetch_lyrics(api_key, title, artist_name)
  end

  def create
    Rails.logger.debug 'createメソッドが呼ばれました'
    Rails.logger.debug { "memo_params: #{memo_params}" }
    @memo = Memo.new(memo_params)
    @memo.user_id = current_user.id
    if @memo.save
      redirect_to memo_path(id: 1)
      # redirect_to memo_path(@memo, title: @memo.song_title, artist_name: @memo.artist_name)
    else
      render 'musixmatch/search', alert: 'メモの開始に失敗しました。'
    end
  end

  def update; end

  def destroy; end

  private

  def memo_params
    params.require(:memo).except(:lyrics).permit(:song_title, :artist_name)
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
