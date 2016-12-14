Rails.application.routes.draw do
  resources :organizations, only: [:index, :show, :edit, :create, :update]
  resources :users, only: [:index, :show, :edit, :create, :update]
  namespace :api do
    resources :users, only: [:create, :update]
    resources :courses, only: [:create]
  end
end