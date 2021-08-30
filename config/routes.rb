Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'stocks#index'

  # Public Endpoints
  resources :stocks, only: [:index, :show], shallow: true do
    resources :price_histories, only: [:index], defaults: { format: :json }
  end

  # System Administrator Endpoints
  ## Note: combine the two controllers
  get  'ml_models',      to: 'machine_learning_models#index'
  get  'ml_models/new',  to: 'machine_learning_models#new'
  get  'model_parameters/new',    to: 'model_parameters#new'
  post 'model_parameters/create', to: 'model_parameters#create'

  namespace :admin do
    resources :prototype, only: [:index, :ws_test]
    resources :model_trainings, only: [:create, :update], defaults: { format: 'json' }
  end

end
