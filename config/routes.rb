Rails.application.routes.draw do

  Mumukit::Login.configure_login_routes! self
  organization_regexp = Regexp.new Mumukit::Platform::Organization::Helpers.valid_name_regex.source[2..-3]

  root to: 'home#index'

  resources :organizations,
                only: [:index, :show, :create, :update, :new],
                constraints: {id: organization_regexp}

  resources :users, only: [:index, :show, :create, :update, :new], constraints: {id: /[^\/]+/}
  namespace :api do
    resources :users, only: [:create, :update],  constraints: {id: /[^\/]+/}
    resources :organizations,
                  only: [:index, :show, :create, :update],
                  constraints: {id: organization_regexp}

    resources :courses, only: [:create]
    constraints(uid: /[^\/]+/, organization: organization_regexp) do
      '/courses/:organization/:course'.tap do |it|
        post "#{it}/students" => 'students#create'
        post "#{it}/students/:uid/attach" => 'students#attach'
        post "#{it}/students/:uid/detach" => 'students#detach'
        post "#{it}/teachers" => 'teachers#create'
        post "#{it}/teachers/:uid/attach" => 'teachers#attach'
        post "#{it}/teachers/:uid/detach" => 'teachers#detach'
      end
    end
  end
end
