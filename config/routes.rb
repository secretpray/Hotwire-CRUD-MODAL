Rails.application.routes.draw do

  resources :posts do
    resources :comments, module: :posts
  end

  resources :comments

  resources :users, only: :show, as: :account
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'posts#index'
end
