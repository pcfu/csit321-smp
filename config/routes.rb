Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'stocks#index'

  # Public Endpoints
  get  'stocks',         to: "stocks#index"  #Default Homepage
  get  'stocks/:id',     to: "stocks#show"   #Stock Detailed Page

  # System Administrator Endpoints
  ## Note: combine the two controllers
  get  'ml_models',      to: 'machine_learning_models#index'
  get  'ml_models/new',  to: 'machine_learning_models#new'
  get  'model_parameters/new',    to: 'model_parameters#new'
  post 'model_parameters/create', to: 'model_parameters#create'

  namespace :admin do
    resources :prototype, only: [:index]
    resources :model_trainings, only: [:index, :create]
  end

end
