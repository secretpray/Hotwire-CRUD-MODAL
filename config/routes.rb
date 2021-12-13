Rails.application.routes.draw do

  resources :posts do
    member do
      put :like, to: 'posts#like'
      get :user_like, to: 'posts#user_like'
    end
    resources :comments, module: :posts
  end

  resources :comments do
    resources :comments, module: :comments
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: :show, as: :account
  root 'posts#index'
end
