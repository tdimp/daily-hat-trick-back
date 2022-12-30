Rails.application.routes.draw do
  resources :teams
  resources :users, only: [:create, :show]
  resources :nhl_teams, only: [:index, :show]
  resources :players, only: [:index, :show]

  post '/login', to: 'sessions#create'
  get '/auth', to: 'users#show'
  delete '/logout', to: 'sessions#destroy'

  get '/players/:player_id/stats', to: 'players#stats'
end
