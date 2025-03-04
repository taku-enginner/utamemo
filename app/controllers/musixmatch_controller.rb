# frozen_string_literal: true

require 'uri'
require 'json'

class MusixmatchController < ApplicationController
  def search
    api_key = Rails.application.credentials[:musixmatch_api_key]
    title = search_params[:title]
    artist_name = search_params[:artist_name]

    # トラックデータ取得
    @track_result = fetch_track(api_key, title, artist_name)

    # 歌詞取得
    @lyrics_result = fetch_lyrics(api_key, title, artist_name)

    # メモ作成用インスタンス
    @memo = Memo.new
  end

  private

  def search_params
    params.except(:commit).permit(:title, :artist_name)
  end

  def fetch_track(api_key, q_track, q_artist)
    track_encoded_uri = URI::DEFAULT_PARSER.escape("https://api.musixmatch.com/ws/1.1/matcher.track.get?apikey=#{api_key}&q_track=#{q_track}&q_artist=#{q_artist}")
    track_response = HTTParty.get(track_encoded_uri)
    track_response_code_check = JSON.parse(track_response)
    # puts "track_response: #{JSON.pretty_generate(track_response_code_check)}"
    return nil if track_response_code_check['message']['header']['status_code'] == 404

    parsed_json_track_response = JSON.parse(track_response)
    parsed_json_track_response['message']['body']['track'].slice('track_name', 'artist_name')
  end

  def fetch_lyrics(api_key, q_track, q_artist)
    lyrics_encoded_uri = URI::DEFAULT_PARSER.escape("https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=#{api_key}&q_track=#{q_track}&q_artist=#{q_artist}")
    lyrics_response = HTTParty.get(lyrics_encoded_uri)
    lyrics_response_code_check = JSON.parse(lyrics_response)
    # puts "lyrics_response: #{JSON.pretty_generate(lyrics_response_code_check)}"
    return nil if lyrics_response_code_check['message']['header']['status_code'] == 404

    parsed_json_lyrics_response = JSON.parse(lyrics_response)
    parsed_json_lyrics_response['message']['body']['lyrics']['lyrics_body']
  end
end
