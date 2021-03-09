Rails.application.routes.draw do
  devise_for :users

  resources :questions, except: [:edit] do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      member do
        patch :best
        post :delete_file
      end
    end
  end

  resources :files, only: [:destroy]

  root to: 'questions#index'
end
