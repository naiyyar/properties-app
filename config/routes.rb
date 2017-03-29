Rails.application.routes.draw do
  
  resources :rental_price_histories
  post '/rate' => 'rater#create', :as => 'rate'
  
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }
  # as :user do
  #   get "/signin" => "devise/sessions#new", :as => :new_user_session
  #   post "/signup" => "devise/sessions#create", :as => :user_session
  #   delete "/" => "devise/sessions#destroy", :as => :destroy_user_session,
  #     :via => Devise.mappings[:user].sign_out_via
  # end

  get '/search', to: 'home#search', as: 'search'
  
  resources :reviews
  resources :uploads
  resources :users

  #multisteps Forms
  resources :user_steps
  resources :building_steps
  resources :unit_steps
  
  resources :buildings do
    resources :reviews
    resources :uploads

    member do 
      get :units
    end

    collection do
      get :contribute
    end
  end

  resources :units do
    resources :reviews
    resources :uploads
    collection do
      get :units_search
    end
  end
  
  root "home#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
