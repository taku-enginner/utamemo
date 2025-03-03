# frozen_string_literal: true

require 'uri'
require 'json'

class MusixmatchController < ApplicationController
  def search
    Rails.application.credentials[:musixmatch_api_key]
    search_params[:title]
    search_params[:artist_name]

    # トラックデータ取得
    @track_result = fetch_track

    # 歌詞取得
    @lyrics_result = fetch_lyrics
  end

  private

  def search_params
    params.permit(:title, :artist_name)
  end

  def fetch_track
    track_encoded_uri = URI::DEFAULT_PARSER.escape("https://api.musixmatch.com/ws/1.1/matcher.track.get?apikey=#{api_key}&q_track=#{q_track}&q_artist=#{q_artist}")
    track_response = HTTParty.get(track_encoded_uri)
    parsed_json_track_response = JSON.parse(track_response.body)
    parsed_json_track_response['message']['body']['track'].slice('track_name', 'artist_name')
  end

  def fetch_lyrics
    lyrics_encoded_uri = URI::DEFAULT_PARSER.escape("https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=#{api_key}&q_track=#{q_track}&q_artist=#{q_artist}")
    lyrics_response = HTTParty.get(lyrics_encoded_uri)
    parsed_json_lyrics_response = JSON.parse(lyrics_response.body)
    parsed_json_lyrics_response['message']['body']['lyrics']['lyrics_body']
  end
end
