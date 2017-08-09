Rails.application.routes.draw do
  resources :items
  resources :tasks
  resources :sessions
  resources :sources
  resources :data
  #get 'home/index'
  root :to => "home#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
