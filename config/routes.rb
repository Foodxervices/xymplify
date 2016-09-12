Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :food_items, only: [:index, :new, :create, :edit, :update, :destroy]
  
  resources :suppliers, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :food_item_imports, only: [:new, :create]

  resources :inventories, only: [:index] do 
    member do 
      patch :update_current_quantity
    end
  end
end
