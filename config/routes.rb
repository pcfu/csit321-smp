Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'placeholder#homepage'
  
  get 'model', to: 'model#list_model'
  get 'addModel', to: 'model#add_model'
  get 'modelDetails', to: 'model#view_model'


  #Frontend Public Application
  get 'stocks', to: "stocks#index" #Default Homepage
  get 'stocks/:id', to: "stocks#show"   #Stock Detailed Page
end
