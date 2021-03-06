Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :users, only: [:create, :update]
    resources :campaigns, only: [:index, :create, :update]
    resources :characters, only: [:index, :show, :create, :update]
    get '/discover-campaigns', to: 'campaigns#discover'
    post '/join-campaign', to: 'campaigns#join'

    get '/profile', to: 'users#profile'

    post '/login', to: 'auth#create'
    get '/auto_login', to: 'auth#auto_login'

    resources :chats, only: [:index, :create, :update]
    resources :messages, only: [:create]
    mount ActionCable.server => '/cable'
  end
end
