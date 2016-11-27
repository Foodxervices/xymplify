require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  mount Sidekiq::Web, at: "/sidekiq"

  root 'home#index'

  get 'retailers' => 'home#retailers', :as => :retailers 

  resource :profile, only: [:edit, :update]

  resources :roles,       only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :food_items,  only: [:show, :edit, :update, :destroy]
  
  resources :suppliers,   only: [:show, :edit, :update, :destroy]

  resources :user_roles,  only: [:show, :edit, :update, :destroy]

  resources :users,       only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :versions,    only: [:show]
  
  resources :messages,    only: [:show, :destroy]

  resources :inventories, only: [:show]

  resources :attachments, only: [:create] do 
    member do 
      post :destroy
    end
  end

  resources :orders,      only: [:show, :edit, :update, :destroy] do 
    member do 
      get :history
      get :mark_as_accepted
      get :mark_as_declined
      patch :mark_as_delivered 
      patch :mark_as_cancelled 
    end
  end

  resources :restaurants, only: [:index, :show, :new, :create, :edit, :update, :destroy] do 
    resources :versions,    only: [:index]
    resources :suppliers,   only: [:index, :new, :create]
    resources :user_roles,  only: [:index, :new, :create]
    resources :food_items,  only: [:index, :new, :create] do
      collection do 
        get :auto_populate
      end
    end
    resources :kitchens, only: [] do 
      resources :food_items, only: [:index]
    end
    resources :categories,  only: [:index] do 
      collection do 
        get :by_supplier
      end
    end
    resources :orders,      only: [:index]
    resources :food_item_imports, only: [:new, :create]
    resources :messages,          only: [:new, :create, :edit, :update]
    
    get 'archived_pos' => 'orders#index', :as => :archived_pos, :defaults => { status: 'archived' }

    resources :carts,       only: [:new] do 
      collection do 
        get :show
        post :add
      end

      member do 
        get :confirm
        post :purchase
      end
    end

    resources :inventories, only: [:index] do 
      member do 
        patch :update
      end
    end

    member do 
      get :dashboard
    end
  end

  resources :kitchens,  only: [:show]
end
