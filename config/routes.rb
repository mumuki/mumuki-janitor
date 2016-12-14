Rails.application.routes.draw do
  root to: 'organizations#index'
  resources :organizations, only: [:index, :show, :edit, :create, :update]
  resources :users, only: [:index, :show, :edit, :create, :update]
  resources :api_clients, only: [:new, :create]
  namespace :api do
    resources :users, only: [:create, :update]
    resources :courses, only: [:create]
    '/courses/:organization/:repository'.tap do |it|
      post "#{it}/students" => 'students#create'
    end
  end
end