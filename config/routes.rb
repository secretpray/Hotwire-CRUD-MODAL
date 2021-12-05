Rails.application.routes.draw do

  resources :posts do
    resources :comments, module: :posts
  end

  resources :comments do
    resources :comments, module: :comments
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: :show, as: :account
  root 'posts#index'
end
