require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => 'sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      post :up
      post :down
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: :create
  end

  resources :questions, concerns: [:votable, :commentable], except: [:edit] do
    resources :answers, shallow: true, concerns: [:votable, :commentable], only: [:create, :update, :destroy] do
      member do
        patch :best
        post :delete_file
      end
    end
    resources :subscriptions, shallow: true, only: [:create, :destroy]
  end

  resources :files, only: :destroy
  resources :awards, only: :index
  resource :authorization, only: [:new, :create] do
    get 'email_confirmation/:confirmation_token', action: :email_confirmation, as: :email_confirmation
  end

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  get 'search/find'
  get 'search', to: 'search#find'

  mount ActionCable.server => '/cable'
end
