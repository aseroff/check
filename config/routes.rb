Rails.application.routes.draw do
  resources :posts, path: 'check-ins'
  resources :relations, only: [:create, :destroy]
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :users, path: 'u' do 
    get "following"
    get "followers"
    get "favorites"
    get "owned"
    get "disconnect"
  end
  resources :games, path: 'g'
  resources :games
  get "import", controller: "games", action: "import"
  get "about", controller: "application"
  get "cookies", controller: "application"
  get "privacy", controller: "application"
  get "terms", controller: "application"
  get "investors", controller: "application"
  get 'stats', controller: "application"
  get "notifications", controller: "users", action: "notifications"
  get 'errors/not_found'
  get 'errors/internal_server_error'
  match "/404", :to => "errors#not_found", :via => :all
  match "/422", :to => "errors#rejected", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  root 'posts#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
