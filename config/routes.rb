Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'placeholder#homepage'
  
  get 'model', to: 'model#list_model'
  get 'viewparam', to: 'viewaddparam#view_add_param' #view ML parameters page
  post 'add_param', to: 'viewaddparam#add_param', as: 'add_param' #add parameters
  get 'modelDetails', to: 'model#view_model'
end
