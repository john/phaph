Rails.application.routes.draw do

  resources :comments

  root 'home#index'
  
  devise_for  :users,
              path_names: {sign_in: "sign_in", sign_out: "sign_out"},
              controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  match '/people/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  
  namespace :admin do
    resources :users, only: [:index] do
      get 'index', on: :collection
    end
  end
  
  resources :categories
  resources :costs
  resources :documents
  resources :grants
  resources :labs
  resources :locations
  resources :memberships
  resources :samples
  resources :users
  
  match '/categories/:id/:slug' => 'categories#show', :via => :get, :as => :slugged_category
  match '/costs/:id/:slug' => 'costs#show', :via => :get, :as => :slugged_cost
  match '/grants/:id/:slug' => 'grants#show', :via => :get, :as => :slugged_grant
  match '/labs/:id/:slug' => 'labs#show', :via => :get, :as => :slugged_lab
  match '/documents/:id/:slug' => 'documents#show', :via => :get, :as => :slugged_document
  match '/samples/:id/:slug' => 'samples#show', :via => :get, :as => :slugged_sample
  match '/people/:id/:slug' => 'users#show', :via => :get, :as => :people
  
end
