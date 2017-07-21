Rails.application.routes.draw do
  resources :posts, path: 'check-ins'
  resources :relations
  devise_for :users
  resources :users do 
    get "following"
    get "followers"
    get "favorites"
    get "owned"
  end
  resources :games
  root 'posts#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
