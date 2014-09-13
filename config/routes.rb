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
  
  match '/new' => 'home#new', :via => :get, :as => :new
  match '/popular' => 'home#popular', :via => :get, :as => :popular

  namespace :admin do
    match '/' => 'base#index', via: [:get], :as => :admin_index
    resources :collections, only: [:index] do
      get 'index', on: :collection
    end
    
    resources :documents, only: [:index] do
      get 'index', on: :collection
      get :follow,  on: :member
      get :unfollow,  on: :member
    end
    
    resources :users, only: [:index] do
      get 'index', on: :collection
    end
  end

  resources :activities
  resources :authentications
  
  resources :collections do
    get :follow,  on: :member
    get :unfollow,  on: :member
  end

  resources :comments
  
  match '/documents/search' => 'documents#search', :via => :get, :as => :search_documents
  resources :documents do
    get 'import', on: :collection
    get :follow,  on: :member
    get :unfollow,  on: :member
  end
  
  resources :locations
  resources :organizations
  resources :memberships
  resources :searches
  
  match '/users/authorize' => 'users#authorize', :via => :get, :as => :user_authorize
  match '/users/dropbox_callback' => 'users#dropbox_callback', :via => :get, :as => :user_dropbox_callback
  
  resources :users, path: 'people' do
    get :documents, on: :member
    get :collections, on: :member
    get :follow,  on: :member
    get :unfollow,  on: :member
  end
  match '/people/:id/:slug' => 'users#show', :via => :get, :as => :people

  match '/organizations/:id/:slug' => 'organizations#show', :via => :get, :as => :slugged_organization
  match '/collections/:id/:slug' => 'collections#show', :via => :get, :as => :slugged_collection
  match '/documents/:id/:slug' => 'documents#show', :via => :get, :as => :slugged_document
  
  
end
