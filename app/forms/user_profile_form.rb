# frozen_string_literal: true

class UserProfileForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # 属性の定義
  attribute :nickname, :string
  attribute :image

  # # バリデーション
  # validates nickname, presence: true

  attr_accessor :user, :profile

  # userとprofileのモデルのインスタンスを初期化
  def initialize(user, profile = nil)
    # 親クラスの初期化を行う
    super()

    # モデルのインスタンスを初期化
    @user = user
    @profile = profile || user.build_profile

    # 各入力項目を初期化
    self.nickname = @user.nickname
  end

  # データを保存
  def save(user_profile_form_params)
    return set_error_and_return_false('Validation failed') unless valid?

    ActiveRecord::Base.transaction do
      @user.update!(
        nickname: user_profile_form_params[:nickname]
      )
      @profile.image.attach(user_profile_form_params[:image]) if user_profile_form_params[:image].present?
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    error_and_return_false("Record invalid: #{e.message}")
  end

  private

  def error_and_return_false(message)
    @error_message = message
    false
  end
end
