Rails.application.routes.draw do
  resources :things
  get 'test/index'
  resources :articles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get 'test', to: 'test#index'

  root "articles#index"
end
