Rails.application.routes.draw do
  root to: 'pages#home'

  get '/routes', to: 'routes#index'
  get '/sensors', to: 'sensors#index'
end
