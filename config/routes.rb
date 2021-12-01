Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/users/login', to: 'users#login'
  post '/users/upload', to: 'users#upload'
  get '/users/token', to: 'users#process_token'
  delete '/users/deactivate', to: 'users#deactivate'
  get '/users/sample', to: 'users#sample'
  get '/users/find/:username', to: 'users#find'
  get '/images/sample', to: 'images#sample'
  get '/images/find/:title', to: 'images#find'
  
  resources :users, only: [:index, :show, :create, :update]
  resources :images, only: [:index, :show, :create, :update, :destroy]

  root to: 'pages#home'

end
