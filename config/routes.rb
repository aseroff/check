Rails.application.routes.draw do
  resources :posts, path: 'checkin'
  resources :relations
  devise_for :users
  resources :users do 
    get "following"
    get "followers"
  end
  resources :games
  root 'posts#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
