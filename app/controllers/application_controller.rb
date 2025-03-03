# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.

  # スマホブラウザでも動作させるため、コメントアウト
  # allow_browser versions: :modern

  def configure_permitted_parameters
    #新規登録時のストロングパラメータにnicknameカラムを追加
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
end
