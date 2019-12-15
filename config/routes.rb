Rails.application.routes.draw do
  resources :billings
  post :create_charge, to: 'billings#create', as: :create_charge
  
  resources :listings do
    collection do
      post :import
      post :export
      get :show_more
    end
  end
  
  resources :broker_fee_percents, only: [:new, :create, :update, :edit]

  resources :featured_buildings, :prices
  resources :featured_comps do
    get :disconnect_building, on: :member
  end

  post '/listings/change_status'     => 'listings#change_status'
  post '/listings/delete_all'        => 'listings#delete_all'
  post '/add_or_update_rent_medians' => 'rent_medians#add_or_update_rent_medians'
  
  get '/price_ranges'                => 'prices#index'
  post '/add_or_update_prices'       => 'prices#add_or_update_prices'
  get "sitemap.xml"                  => "buildings#sitemap", format: :xml,             as: :sitemap
  
  scope :module => 'buttercms' do
    get '/categories/:slug'          => 'categories#show',                             :as => :buttercms_category
    get '/tags/:slug'                => 'tags#show',                                   :as => :buttercms_tag
    get '/author/:slug'              => 'authors#show',                                :as => :buttercms_author

    get '/blog/rss'                  => 'feeds#rss',        :format => 'rss',          :as => :buttercms_blog_rss
    get '/blog/atom'                 => 'feeds#atom',       :format => 'atom',         :as => :buttercms_blog_atom
    get '/blog/sitemap.xml'          => 'feeds#sitemap',    :format => 'xml',          :as => :buttercms_blog_sitemap

    get '/blog(/page/:page)'         => 'posts#index',      :defaults => {:page => 1}, :as => :buttercms_blog
    get '/blog/:slug'                => 'posts#show',                                  :as => :buttercms_post
  end

  resources :management_companies, except: [:show] do
    member do
      get :managed_buildings
      get :set_availability_link
    end
  end

  get 'no-fee-management-companies-nyc/:id', to: 'management_companies#show',              as: :no_fee_company
  get 'load_more_reviews',                   to: 'management_companies#load_more_reviews', as: :load_more_reviews
  
  resources :neighborhood_links, :review_flags, :contacts, :rental_price_histories
  
  get '/about', to: 'contacts#about'
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
      get :featured_by
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

    get :photos, on: :collection
  end

  resources :document_downloads do
    get :downloaders, on: :collection
  end

  get '/documents', to: 'uploads#documents', as: 'documents'
  
  resources :users do
    member do
      get :contribution
      get :saved_buildings
      get '/managertools/:type',        to: 'users#managertools',     as: :managertools
      get '/managertools/:type/new',    to: 'featured_buildings#new', as: :new_manager_featured_building
      # get '/managertools/billing/new',  to: 'billings#new',           as: :new_builling
    end
  end

  #multisteps Forms
  resources :user_steps, :building_steps, :unit_steps
  
  resources :units do
    resources :reviews
    resources :uploads
    collection do
      get :units_search
    end
  end
  
  get '/:searched_by/:search_term', to: 'home#search',              as: 'search' #must be after buildings resource
  get '/custom_search',             to: 'home#search' #must be after buildings resource
  get '/location_search',           to: 'home#search'
  get '/current_location',          to: 'home#search'
  get '/auto_search',               to: 'home#auto_search',         as: 'auto_search'
  get '/terms_of_service',          to: 'home#tos',                 as: 'tos'
  post '/load_infobox',             to: 'home#load_infobox',        as: 'load_infobox'
  post '/set_split_view_type',      to: 'home#set_split_view_type'
  get '/get_images',                to: 'home#get_images'

  post '/favorite',                 to: 'buildings#favorite',       as: :favorite
  get '/unfavorite',                to: 'buildings#unfavorite',     as: :unfavorite

  # Dynamic error pages
  get '/403',                       to: 'errors#access_denied'
  get '/404',                       to: 'errors#not_found'
  get '/422',                       to: 'errors#unacceptable'
  get '/500',                       to: 'errors#internal_server_error'
  get 'errors/not_found'
  get 'errors/internal_server_error'
  
  root 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable
end
