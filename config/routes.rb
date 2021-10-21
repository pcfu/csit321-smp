Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'stocks#index'

  # Registration
  scope(path_names: { new: '/' }) do
    resources :users, path: 'register', only: [:new, :create]
  end

  # Login
  scope(path_names: { new: '/' }) do
    resources :sessions, path: 'login', only: [:new, :create]
  end
  post 'logout', to: 'sessions#destroy'

  # Stocks and Prices
  resources :stocks, only: [:index, :show], shallow: true do
    collection do
      resources :price_histories do
        post 'batch_create', on: :collection, defaults: { format: :json }
      end
    end

    member do
      resources :price_histories, only: [:index], defaults: { format: :json }
      resources :technical_indicators do
        post 'batch_create', on: :collection, defaults: { format: :json }
      end
    end
  end

  resources :favorites, only: [:index, :show, :create], :path => 'portfolio'
  resources :favorite
  get 'favorites/update'
  post 'portfolio/:id', to: 'favorites#destroy'

  resources :threshold, only: [:create, :destroy]
  post 'threshold/update'

 

  
  
  # System Administrator Endpoints
  ## Note: combine the two controllers
  get  'ml_models',      to: 'machine_learning_models#index'
  get  'ml_models/new',  to: 'machine_learning_models#new'
  get  'model_parameters/new',    to: 'model_parameters#new'
  post 'model_parameters/create', to: 'model_parameters#create'

  namespace :admin do
    resources :prototype, only: [:index]
    resources :model_configs, only: [:show], defaults: { format: 'json' }
    resources :configurationexit
    
    resources :model_trainings, only: [:update], defaults: { format: 'json' } do
      post 'batch_enqueue', on: :collection, defaults: { format: 'json' }
    end

    resources :price_predictions, only: [:create], defaults: { format: 'json' } do
      post 'enqueue', on: :collection, defaults: { format: 'json' }
    end
  end

  mount ActionCable.server => '/websocket/:id', constraints: { id: /[\w\-\.]+/ }

   #Errors Custom Routes
  match '/404', via: :all, to: 'errors#not_found'
  match "/(*url)", via: :all, to: 'errors#not_found'
  match '/422', via: :all, to: 'errors#unprocessable_entity'
  match '/500', via: :all, to: 'errors#server_error'
  #get   '*path', to: sessions_url
  
end


