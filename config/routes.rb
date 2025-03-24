# frozen_string_literal: true

Rails.application.routes.draw do
  resources :memos, only: %i[index show create update destroy]
  devise_for :users
  get 'up' => 'rails/health#show', as: :rails_health_check
  
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  get 'musixmatch/search'
  resources :users do
    resource :profile, only: %i[show edit update]
  end
  # resources :mypage, only: %i[index] do
  # end

  root 'top#index'
  get 'help' => 'top#help'
end
