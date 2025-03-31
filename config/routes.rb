# frozen_string_literal: true

Rails.application.routes.draw do
  resources :memos, only: %i[index show create update destroy] do
    resource :settings, only: %i[edit update]
    resources :favorites, only: %i[create destroy]
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  get 'musixmatch/search'
  resources :users do
    resource :profile, only: %i[show edit update] do
      member do
        get 'my_memos'
      end
    end
  end

  root 'top#index'
  get 'help' => 'top#help'
end
