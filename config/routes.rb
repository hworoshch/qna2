Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :up
      post :down
    end
  end

  resources :questions, concerns: [:votable], except: [:edit] do
    resources :answers, shallow: true, concerns: [:votable], only: [:create, :update, :destroy] do
      member do
        patch :best
        post :delete_file
      end
    end
  end

  resources :files, only: :destroy
  resources :awards, only: :index

  root to: 'questions#index'
end
