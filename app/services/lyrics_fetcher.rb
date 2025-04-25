# frozen_string_literal: true

class LyricsFetcher
  # キーワード引数で受け取っている。ハッシュの形で引数を渡せる。
  def self.call(api_key:, q_track:, q_artist:)
    lyrics_encoded_uri = URI::DEFAULT_PARSER.escape("https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=#{api_key}&q_track=#{q_track}&q_artist=#{q_artist}")
    lyrics_response = HTTParty.get(lyrics_encoded_uri)
    lyrics_response_code_check = JSON.parse(lyrics_response)
    Rails.logger.debug { "lyrics_response: #{JSON.pretty_generate(lyrics_response_code_check)}" }
    return nil if lyrics_response_code_check['message']['header']['status_code'] == 404

    parsed_json_lyrics_response = JSON.parse(lyrics_response)
    parsed_json_lyrics_response['message']['body']['lyrics']['lyrics_body']
  rescue StandardError => e
    Rails.logger.error("standard error: #{e.message}")
    nil
  end
end
