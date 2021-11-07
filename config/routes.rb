require 'sidekiq/web'
require 'sidekiq-scheduler/web'


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

    defaults format: :json do
      member do
        resources :price_histories, only: [:index] do
          get 'sister_prices', on: :collection
        end

        resources :technical_indicators do
          post 'batch_create', on: :collection
        end
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
  namespace :admin do
    resources :prototype, only: [:index]
    resources :model_configs, only: [:show], defaults: { format: 'json' }
    resources :model_parameters, only: [:index, :show, :new, :create]
    post 'model_parameters/delete', to: 'model_parameters#destroy'
    post 'model_parameters/setActive', to: 'model_parameters#setActive'
    post 'model_parameters/train', to: 'model_parameters#train'
    resources :schedule, only: [:index, :edit, :update]

    defaults format: :json do
      resources :model_trainings, only: [:update] do
        post 'batch_enqueue', on: :collection
      end

      resources :price_predictions, only: [:create] do
        post 'batch_enqueue', on: :collection
      end

      resources :recommendations, only: [:create] do
        post 'batch_enqueue', on: :collection
      end
    end
  end

  mount ActionCable.server => '/websocket/:id', constraints: { id: /[\w\-\.]+/ }
  mount Sidekiq::Web => "/sidekiq"

  #Errors Custom Routes
  match '/404', via: :all, to: 'errors#not_found'
  match "/(*url)", via: :all, to: 'errors#not_found'
  match '/422', via: :all, to: 'errors#unprocessable_entity'
  match '/500', via: :all, to: 'errors#server_error'
  #get   '*path', to: sessions_url

end
