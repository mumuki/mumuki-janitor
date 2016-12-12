Rails.application.routes.draw do
  resources :organizations, only: [:index, :show, :edit, :create, :update]
  resources :users, only: [:index, :show, :edit, :create, :update]
  namespace :api do
    resources :users, only: [:create]
    put '/users/:uid' => 'users#update', uid: /[\w.@]+/
  end
end
