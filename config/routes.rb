Rails.application.routes.draw do
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  # # http://sreeharikmarar.blogspot.com/2013/07/ruby-on-rails-practice-some-safe.html
  # match '/dropbox/authorize' => 'dropbox#authorize' , :method => :get , :as => :dropbox_auth
  # match '/dropbox/callback' => 'dropbox#callback' , :method => :get , :as =>  :dropbox_callback
  
  root 'home#index'
  
  devise_for  :users,
              path_names: {sign_in: "sign_in", sign_out: "sign_out"},
              controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: "registrations" }
  match '/people/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/people/set_username' => 'users#set_username', via: :get, :as => :set_username
  
  
  namespace :admin do
    resources :users, only: [:index] do
      get 'index', on: :collection
    end
  end
  
  resources :authentications
  resources :categories
  resources :comments
  resources :costs
  
  match '/documents/search' => 'documents#search', :via => :get, :as => :search_documents
  resources :documents do
    get 'import', on: :collection
  end
  
  resources :grants
  resources :organizations
  resources :locations
  resources :memberships
  resources :samples
  
  match '/users/authorize' => 'users#authorize', :via => :get, :as => :user_authorize
  match '/users/dropbox_callback' => 'users#dropbox_callback', :via => :get, :as => :user_dropbox_callback
  resources :users
  
  match '/categories/:id/:slug' => 'categories#show', :via => :get, :as => :slugged_category
  match '/costs/:id/:slug' => 'costs#show', :via => :get, :as => :slugged_cost
  match '/grants/:id/:slug' => 'grants#show', :via => :get, :as => :slugged_grant
  match '/organizations/:id/:slug' => 'organizations#show', :via => :get, :as => :slugged_organization
  match '/documents/:id/:slug' => 'documents#show', :via => :get, :as => :slugged_document
  match '/samples/:id/:slug' => 'samples#show', :via => :get, :as => :slugged_sample
  match '/people/:id/:slug' => 'users#show', :via => :get, :as => :people
  
end
