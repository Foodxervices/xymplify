require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  mount Sidekiq::Web, at: "/sidekiq"

  authenticated :user do
    root 'restaurants#index', as: :authenticated_root
  end

  root 'home#index'

  get 'retailers' => 'home#retailers', :as => :retailers
  get 'how_it_works' => 'home#how_it_works', :as => :how_it_works
  get 'faqs' => 'home#faqs', :as => :faqs

  resource :profile, only: [:edit, :update]

  resources :roles,       only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :configs,     only: [:index, :edit, :update]

  resources :food_items,  only: [:show, :destroy]

  resources :graphs, only: [:index]

  resources :food_categories,  only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      patch :update_priority
    end
  end

  resources :suppliers,   only: [:show, :destroy] do
    collection do
      patch :update_priority
    end
  end

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
      get :new_attachment
      patch :add_attachment
      patch :mark_as_accepted
      patch :mark_as_declined
      patch :mark_as_cancelled

      get :confirm_delivery
      patch :deliver
    end
  end

  resources :payments, only: [:edit, :update]

  resources :restaurants, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :versions,    only: [:index]
    resources :payments,    only: [:index]
    resources :suppliers,   only: [:index, :new, :create, :edit, :update] do
      resources :supplier_orders, only: [:index], path: '/orders'
    end
    resources :user_roles,  only: [:index, :new, :create]
    resources :food_items,  only: [:index, :new, :create, :edit, :update]
    resources :kitchens, only: [:index, :new, :create, :edit, :update] do
      resources :versions,    only: [:index]
      resources :food_items,  only: [:index]
      resources :inventories, only: [:index]
      resources :food_item_imports, only: [:new, :create]
      resources :messages,          only: [:new, :create, :edit, :update]
    end
    resources :food_item_imports, only: [:new, :create]
    resources :messages,          only: [:new, :create, :edit, :update]

    resources :inventories, only: [:index] do
      member do
        patch :update
      end
    end

    member do
      get :dashboard
    end
  end

  resources :kitchens, only: [:index, :show] do
    resources :food_items,  only: [:show]
    resources :orders,   only: [:index]
    get 'archived_pos' => 'orders#index', :as => :archived_pos, :defaults => { status: 'archived' }
    resources :categories,  only: [:index] do
      collection do
        get :by_supplier
        get :frequently_ordered
      end
    end
    resources :carts,       only: [:new] do
      collection do
        get :show
        post :add
        post :purchase
      end

      member do
        post :update_request_for_delivery_start_at
        post :update_request_for_delivery_end_at
        get :confirm
        post :do_confirm
      end
    end

    member do
      get :dashboard
    end
  end
end
