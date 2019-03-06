Rails.application.routes.draw do
  
  
  resources :prices
  get '/price_ranges' => 'prices#index'
  post '/add_or_update_prices' => 'prices#add_or_update_prices'

  get "sitemap.xml" => "buildings#sitemap", format: :xml, as: :sitemap
  
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

  resources :management_companies, except: [:show] do
    member do
      get :managed_buildings
    end
  end

  get 'no-fee-management-companies-nyc/:id' => 'management_companies#show', as: :no_fee_company

  get 'load_more_reviews', to: 'management_companies#load_more_reviews', as: :load_more_reviews
  
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
      get :saved_buildings
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
  
  get '/:searched_by/:search_term', to: 'home#search', as: 'search' #must be after buildings resource
  get '/auto_search', to: 'home#auto_search', as: 'auto_search'
  get '/terms_of_service', to: 'home#tos', as: 'tos'
  post '/load_infobox', to: 'home#load_infobox', as: 'load_infobox'

  get '/favorite' => 'buildings#favorite', as: :favorite
  get '/unfavorite' => 'buildings#unfavorite', as: :unfavorite
  
  root "home#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
end
