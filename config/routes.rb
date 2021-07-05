Rails.application.routes.draw do
  mount StripeEvent::Engine, at: '/stripe-events'
  
  resources :billings, except: :edit
  
  post :create_charge,        to: 'billings#create',                as: :create_charge
  get  :delete_card,          to: 'billings#delete_card',           as: :delete_card
  post :create_new_card,      to: 'billings#create_new_card',       as: :create_new_card
  post :pay_using_saved_card, to: 'billings#pay_using_saved_card',  as: :pay_using_saved_card

  resources :featured_buildings

  resources :management_companies, except: [:show] do
    get :managed_buildings, on: :member
  end

  get 'no-fee-management-companies-nyc/:id', to: 'management_companies#show', as: :no_fee_company
  post '/rate' => 'rater#create', :as => :rate
  
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :buildings do
    resources :reviews
    resources :uploads, only: [:edit, :new, :create, :index]

    collection do
      get :contribute
      post :import
    end
  end

  resources :uploads, except: :show do
    collection do
      get :photos
      get :set_sort_order
    end
  end
  
  resources :users do
    member do
      get :contribution
      get :saved_buildings
    end
  end
  
  get '/:searched_by/:search_term', to: 'home#search', as: :search
  get '/auto_search', to: 'home#auto_search',  as: :auto_search
  
  # Error pages
  get '/403', to: 'errors#access_denied'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_server_error'
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
