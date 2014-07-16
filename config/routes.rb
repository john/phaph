Rails.application.routes.draw do

  root 'home#index'
  
  devise_for  :users,
              path_names: {sign_in: "sign_in", sign_out: "sign_out"},
              controllers: { omniauth_callbacks: 'omniauth_callbacks' }
              
  match '/people/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  
  namespace :admin do
    
    resources :users, only: [:index] do
      get 'index', on: :collection
      # delete 'destroy', on: :member
    end
    
  end
  
  resources :categories
  match '/categories/:id/:slug' => 'categories#show', :via => :get, :as => :slugged_category
  
  resources :costs
  match '/costs/:id/:slug' => 'costs#show', :via => :get, :as => :slugged_cost
  
  resources :grants
  match '/grants/:id/:slug' => 'grants#show', :via => :get, :as => :slugged_grant
  
  resources :labs
  match '/labs/:id/:slug' => 'labs#show', :via => :get, :as => :slugged_lab
  
  resources :memberships
  
  resources :papers
  match '/papers/:id/:slug' => 'papers#show', :via => :get, :as => :slugged_paper
  
  resources :samples
  match '/samples/:id/:slug' => 'samples#show', :via => :get, :as => :slugged_sample
  
  resources :users
  match '/people/:id/:slug' => 'users#show', :via => :get, :as => :people
  
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
