Rails.application.routes.draw do
  
  devise_for  :users,
              path_names: {sign_in: "sign_in", sign_out: "sign_out"},
              controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: "registrations" }
  match '/people/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/people/set_username' => 'users#set_username', via: :get, :as => :set_username
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  # # http://sreeharikmarar.blogspot.com/2013/07/ruby-on-rails-practice-some-safe.html
  # match '/dropbox/authorize' => 'dropbox#authorize' , :method => :get , :as => :dropbox_auth
  # match '/dropbox/callback' => 'dropbox#callback' , :method => :get , :as =>  :dropbox_callback
  
  root 'home#index'
  
  namespace :admin do
    match '/' => 'base#index', via: [:get], :as => :admin_index
    resources :collections, only: [:index] do
      get 'index', on: :collection
    end
    
    resources :documents, only: [:index] do
      get 'index', on: :collection
    end
    
    resources :users, only: [:index] do
      get 'index', on: :collection
    end
  end
  
  resources :authentications
  resources :collections
  resources :comments
  
  match '/documents/search' => 'documents#search', :via => :get, :as => :search_documents
  resources :documents do
    get 'import', on: :collection
  end
  
  resources :locations
  resources :organizations
  resources :memberships
  resources :searches
  
  match '/users/authorize' => 'users#authorize', :via => :get, :as => :user_authorize
  match '/users/dropbox_callback' => 'users#dropbox_callback', :via => :get, :as => :user_dropbox_callback
  resources :users
  
  match '/organizations/:id/:slug' => 'organizations#show', :via => :get, :as => :slugged_organization
  match '/collections/:id/:slug' => 'collections#show', :via => :get, :as => :slugged_collection
  match '/documents/:id/:slug' => 'documents#show', :via => :get, :as => :slugged_document
  match '/people/:id/:slug' => 'users#show', :via => :get, :as => :people
  
end
