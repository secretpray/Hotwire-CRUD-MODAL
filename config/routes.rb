Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'

  resources :posts
  resources :users, only: :show, as: :account
end
