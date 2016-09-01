Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :food_items, only: [:index]
end
