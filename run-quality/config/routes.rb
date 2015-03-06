Rails.application.routes.draw do
  root to: 'pages#home'

  get '/routes', to: 'routes#index'
  get '/routes/:id', to: 'routes#show'
  get '/sensors', to: 'sensors#index'
end
