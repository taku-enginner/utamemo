class AutocompleteController < ApplicationController
  require 'net/http'
  require 'json'

  def songs
    query = params[:query].presence
    return render json: { results: [] } if query.blank?

    api_key = Rails.application.credentials[:musixmatch_api_key]
    if api_key.blank?
      Rails.logger.error "Musixmatch APIキーが設定されていません"
      return render json: { error: "APIキーが設定されていません" }, status: 500
    end

    # URLエンコードする
    encoded_query = URI.encode_www_form(q_track: query, apikey: api_key)
    url = URI("https://api.musixmatch.com/ws/1.1/track.search?#{encoded_query}")

    results = fetch_results(url, "track_list", "track", "track_name")

    if results.nil?
      return render json: { error: "APIリクエストが失敗しました" }, status: 500
    end

    render json: { results: results }
  end

  def artists
    query = params[:query].presence
    return render json: { results: [] } if query.blank?
  
    api_key = Rails.application.credentials[:musixmatch_api_key]
    unless api_key.present?
      Rails.logger.error "Musixmatch APIキーが設定されていません"
      return render json: { error: "APIキーが設定されていません" }, status: :internal_server_error
    end
  
    url = build_musixmatch_url("artist.search", query, api_key)
  
    results = fetch_results(url, "artist_list", "artist", "artist_name")
    unless results
      return render json: { error: "APIリクエストが失敗しました" }, status: :internal_server_error
    end
  
    render json: { results: results }
  end
  
  private
  
  def build_musixmatch_url(endpoint, query, api_key)
    encoded_query = URI.encode_www_form(q_artist: query, apikey: api_key)
    URI("https://api.musixmatch.com/ws/1.1/#{endpoint}?#{encoded_query}")
  end

  def fetch_results(url, list_key, object_key, field_key)
    begin
      response = Net::HTTP.get(url)
      data = JSON.parse(response)

      if data.dig("message", "header", "status_code") != 200
        Rails.logger.error "Musixmatch APIエラー: #{data}"
        return nil
      end

      data.dig("message", "body", list_key)&.map { |item| item[object_key][field_key] } || []
    rescue StandardError => e
      Rails.logger.error "APIリクエスト中にエラー発生: #{e.message}"
      return nil
    end
  end
end
