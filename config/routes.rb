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
  resources :games
  get "import", controller: "games", action: "import"
  get "notifications", controller: "users", action: "notifications"
  root 'posts#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
