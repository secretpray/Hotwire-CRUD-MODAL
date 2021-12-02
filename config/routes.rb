Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :posts do
    resources :comments, module: :posts
  end
  resources :users, only: :show, as: :account

  root 'posts#index'
end
