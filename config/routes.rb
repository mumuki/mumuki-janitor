Rails.application.routes.draw do
  root to: 'organizations#index'
  resources :organizations, only: [:index, :show, :edit, :create, :update]
  resources :users, only: [:index, :show, :edit, :create, :update]
  namespace :api do
    resources :users, only: [:create, :update], constraints: { id: /[^\/]+/ }
    resources :courses, only: [:create]
    '/courses/:organization/:course'.tap do |it|
      post "#{it}/students" => 'students#create'
    end
  end
end