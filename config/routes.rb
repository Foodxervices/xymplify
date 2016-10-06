Rails.application.routes.draw do
  devise_for :users

  root 'restaurants#index'

  resource :profile, only: [:edit, :update]

  resources :roles,       only: [:index, :new, :create, :edit, :update, :destroy]

  resources :food_items,  only: [:show, :edit, :update, :destroy]
  
  resources :suppliers,   only: [:show, :edit, :update, :destroy]

  resources :user_roles,  only: [:show, :edit, :update, :destroy]

  resources :users,       only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :versions,    only: [:show]

  resources :food_item_imports, only: [:new, :create]

  resources :orders,      only: [:show, :edit, :update, :destroy] do 
    member do 
      patch :mark_as_shipped 
      patch :mark_as_cancelled
    end
  end

  resources :restaurants, only: [:index, :show, :new, :create, :edit, :update, :destroy] do 
    resources :suppliers,   only: [:index, :new, :create]
    resources :user_roles,  only: [:index, :new, :create]
    resources :food_items,  only: [:index, :new, :create]
    resources :categories,  only: [:index]
    resources :orders,      only: [:index]

    resources :carts,       only: [:new] do 
      collection do 
        post :add
        post :purchase
      end
    end

    resources :inventories, only: [:index] do 
      member do 
        patch :update_current_quantity
      end
    end
  end

  resources :kitchens,  only: [:show]
end
