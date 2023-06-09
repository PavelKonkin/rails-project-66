# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    resources :repositories, only: %i[index new create show]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope module: :web do
    root 'welcome#index'
  end

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
  end

  scope module: :web do
    get :sessions, to: 'sessions#destroy'
  end
end
