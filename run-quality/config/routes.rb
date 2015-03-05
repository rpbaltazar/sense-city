Rails.application.routes.draw do
  root to: 'pages#home'

  get '/routes', to: 'routes#index'
end
