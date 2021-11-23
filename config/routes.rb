Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :create, :update, :destroy]
  resources :images, only: [:index, :show, :create, :update, :destroy]

  get '/user', to: 'users#profile'
  get '/users/:username', to: 'users#show'

end
