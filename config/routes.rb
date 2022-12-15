Rails.application.routes.draw do
  resources :teams
  resources :users, only: [:create, :show]

  post '/login', to: 'sessions#create'
  get '/auth', to: 'users#show'
  delete '/logout', to: 'sessions#destroy'
end
