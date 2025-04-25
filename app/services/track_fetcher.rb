# frozen_string_literal: true

class TrackFetcher
  # キーワード引数で受け取っている。ハッシュの形で引数を渡せる。
  def self.call(api_key:, q_track:, q_artist:)
    track_encoded_uri = URI::DEFAULT_PARSER.escape("https://api.musixmatch.com/ws/1.1/matcher.track.get?apikey=#{api_key}&q_track=#{q_track}&q_artist=#{q_artist}")
    track_response = HTTParty.get(track_encoded_uri)
    track_response_code_check = JSON.parse(track_response)
    return nil if track_response_code_check['message']['header']['status_code'] == 404

    parsed_json_track_response = JSON.parse(track_response)
    parsed_json_track_response['message']['body']['track'].slice('track_name', 'artist_name')
  rescue StandardError => e
    Rails.logger.error("standard error: #{e.message}")
    nil
  end
end
