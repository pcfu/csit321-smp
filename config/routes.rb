Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'placeholder#homepage'

  # Public Endpoints
  get 'stocks',         to: "stocks#index"  #Default Homepage
  get 'stocks/:id',     to: "stocks#show"   #Stock Detailed Page

  # System Administrator Endpoints
  get 'ml_models',      to: 'machine_learning_models#index'
  get 'ml_models/new',  to: 'machine_learning_models#new'

end
