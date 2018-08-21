Rails.application.routes.draw do
  
  
  scope :module => 'buttercms' do
    get '/categories/:slug' => 'categories#show', :as => :buttercms_category
    get '/tags/:slug' => 'tags#show', :as => :buttercms_tag
    get '/author/:slug' => 'authors#show', :as => :buttercms_author

    get '/blog/rss' => 'feeds#rss', :format => 'rss', :as => :buttercms_blog_rss
    get '/blog/atom' => 'feeds#atom', :format => 'atom', :as => :buttercms_blog_atom
    get '/blog/sitemap.xml' => 'feeds#sitemap', :format => 'xml', :as => :buttercms_blog_sitemap

    get '/blog(/page/:page)' => 'posts#index', :defaults => {:page => 1}, :as => :buttercms_blog
    get '/blog/:slug' => 'posts#show', :as => :buttercms_post
  end

  resources :management_companies do
    member do
      get :managed_buildings
    end
  end
  
  resources :neighborhood_links
  resources :review_flags
  resources :contacts
  get '/about', to: 'contacts#about'
  resources :rental_price_histories
  post '/rate' => 'rater#create', :as => 'rate'
  
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # as :user do
  #   get "/signin" => "devise/sessions#new", :as => :new_user_session
  #   post "/signup" => "devise/sessions#create", :as => :user_session
  #   delete "/" => "devise/sessions#destroy", :as => :destroy_user_session,
  #     :via => Devise.mappings[:user].sign_out_via
  # end

  resources :buildings do
    resources :reviews
    resources :uploads

    member do 
      get :units
      get '/disconnect_building', to: 'buildings#disconnect_building', as: 'disconnect_building'
    end

    collection do
      get :contribute
      post :import
    end
  end

  get '/:searched_by/:search_term', to: 'home#search', as: 'search' #must be after buildings resource
  get '/auto_search', to: 'home#auto_search', as: 'auto_search'
  get '/terms_of_service', to: 'home#tos', as: 'tos'
  
  resources :reviews do 
    get :destroy_scraped_reviews, on: :collection
  end
  
  resources :useful_reviews
  resources :uploads do
    member do 
      get :rotate
    end
  end

  resources :document_downloads do
    get :downloaders, on: :collection
  end

  get '/documents', to: 'uploads#documents', as: 'documents'
  
  resources :users do
    member do
      get '/contribution', to: 'users#contribution', as: 'contribution'
    end
  end

  #multisteps Forms
  resources :user_steps
  resources :building_steps
  resources :unit_steps

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
