Rails.application.routes.draw do
  resources :organizations, only: [:index, :show, :edit, :create, :update]
  resources :users, only: [:index, :show, :edit, :create, :update]
end
