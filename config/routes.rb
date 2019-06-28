Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :users, only: [:create, :update]
    resources :campaigns, only: [:index]

    get '/profile', to: 'users#profile'

    post '/login', to: 'auth#create'
    get '/auto_login', to: 'auth#auto_login'
  end
end
