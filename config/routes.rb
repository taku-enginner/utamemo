# frozen_string_literal: true

Rails.application.routes.draw do
  get 'musixmatch/search'
  devise_for :users
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  root 'top#index'
end
