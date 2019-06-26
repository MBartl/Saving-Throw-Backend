Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :users, only: [:create, :update]

    post '/login', to: 'auth#create'
    get '/profile', to: 'users#profile'
  end
end
