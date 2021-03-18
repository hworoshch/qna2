Rails.application.routes.draw do
  devise_for :users

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
  end

  resources :files, only: :destroy
  resources :awards, only: :index

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
