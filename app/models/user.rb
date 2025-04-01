# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :memos, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first

    if user
      user.update(provider: auth.provider, uid: auth.uid) unless user.provider
      user
    else
      create(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        uid: auth.uid,
        nickname: auth.info.name
      )
    end
  end
end
