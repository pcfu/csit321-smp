Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'stocks#index'

  # Public Endpoints
  get 'stocks',         to: "stocks#index"  #Default Homepage
  get 'stocks/:id',     to: "stocks#show"   #Stock Detailed Page

  # System Administrator Endpoints
  get 'ml_models',      to: 'machine_learning_models#index'
  get 'ml_models/new',  to: 'machine_learning_models#new'


  # Temp
  get 'model', to: 'model#list_model'
  get 'viewparam', to: 'viewaddparam#view_add_param' #view ML parameters page
  post 'add_param', to: 'viewaddparam#add_param', as: 'add_param' #add parameters
  get 'modelDetails', to: 'model#view_model'

end
