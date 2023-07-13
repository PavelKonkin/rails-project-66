# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    resources :repositories, only: %i[index new create show] do
      resources :checks, only: %i[show create]
    end

    root 'welcome#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth

    get :sessions, to: 'sessions#destroy'
  end

  namespace :api do
    post '/checks', to: 'checks#on_push'
  end
  # scope module: :web do
  #   root 'welcome#index'
  # end

  # scope module: :web do
  #   post 'auth/:provider', to: 'auth#request', as: :auth_request
  #   get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
  # end

  # scope module: :web do
  #   get :sessions, to: 'sessions#destroy'
  # end
end
