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
  get 'about_us' => 'home#about_us', :as => :about_us

  resource :profile, only: [:edit, :update]

  resources :roles,       only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :configs,     only: [:index, :edit, :update]

  resources :food_items,  only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :graphs, only: [:index]

  resources :food_categories,  only: [:index, :new, :create, :edit, :update, :destroy] do
    collection do
      patch :update_priority
    end
  end

  resources :suppliers,   only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :supplier_orders, only: [:index], path: '/orders'

    collection do
      patch :update_priority
    end
  end

  resources :user_roles,  only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :users,       only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :versions,    only: [:index, :show]

  resources :messages,    only: [:show, :new, :create, :edit, :update, :destroy]

  resources :inventories, only: [:index, :show] do
    member do
      patch :update
    end
  end

  resources :food_item_imports, only: [:new, :create]

  resources :attachments, only: [:create] do
    member do
      post :destroy
    end
  end

  resources :archived_pos, controller: 'orders', only: [:index], status: 'archived'
  resources :orders,      only: [:index, :show, :edit, :update, :destroy] do
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

  resources :payments, only: [:index, :edit, :update]

  resources :restaurants, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :kitchens, only: [:index, :new, :create, :edit, :update]

    member do
      get :dashboard
    end
  end

  resources :categories,  only: [:index] do
    collection do
      get :by_supplier
      get :frequently_ordered
    end
  end

  resources :kitchens, only: [:index, :show] do
    resources :food_items,  only: [:index]
    
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
