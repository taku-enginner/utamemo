# frozen_string_literal: true

require 'uri'
require 'json'

class MusixmatchController < ApplicationController
  def search
    api_key = Rails.application.credentials[:musixmatch_api_key]
    @title = search_params[:title]
    @artist_name = search_params[:artist_name]

    # メモ作成用インスタンス
    @memo = Memo.new

    # トラック情報と歌詞をturbo_framesで遅延読み込み
    if turbo_frame_request?

      lyrics_result = LyricsFetcher.call(api_key: api_key, q_track: @title, q_artist: @artist_name)

      track_result = TrackFetcher.call(api_key: api_key, q_track: @title, q_artist: @artist_name)

      render partial: 'musixmatch/search', locals: {
        lyrics_result: lyrics_result,
        track_result: track_result
      }

    else
      render :search
    end
  end

  private

  def search_params
    params.except(:commit).permit(:title, :artist_name)
  end
end
