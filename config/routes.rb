Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :food_items, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :inventories, only: [:index] do 
    member do 
      patch :update_current_quantity
    end
  end
end
