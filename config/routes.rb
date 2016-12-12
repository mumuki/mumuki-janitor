Rails.application.routes.draw do
  resources :organizations, only: [:index, :show, :edit, :create, :update]
  resources :users, only: [:index, :show, :edit, :create, :update]
  namespace :api do
    resources :users, only: [:create]
    put '/users/:email' => 'users#update'
  end
end
