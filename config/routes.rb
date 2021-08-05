Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'placeholder#homepage'
  
  get 'machineModel', to: 'machine_model#machine_model_list'
  get 'addMachineModel', to: 'machine_model#add_machine_model'


  #Frontend Public Application
  get 'public', to: "stock_data#index" #Default Homepage
  get 'public/:id', to: "stock_data#show"   #Stock Detailed Page
end
