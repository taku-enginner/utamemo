class MusixmatchController < ApplicationController
  def search
    p "params: #{params}"
    p "search_params: #{search_params}"
    p "api_key: #{Rails.application.credentials[:musixmatch_api_key]}"
  end

  private

  def search_params
    params.permit(:title, :artist_name, :lyrics)
  end
end
