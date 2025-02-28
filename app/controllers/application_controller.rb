# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # スマホブラウザでも動作させるため、コメントアウト
  # allow_browser versions: :modern
end
