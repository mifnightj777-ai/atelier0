Rails.application.routes.draw do 
  get "up" => "rails/health#show", as: :rails_health_check
  get 'focus/index'
  get '/@:username', to: 'users#show', as: :user_profile
  get 'notifications/index'
  root "fragments#index"
  get 'users/show'
  get 'focus', to: 'ideas#new', as: :focus_studio
  get 'mailbox', to: 'letters#index', as: :mailbox
  get 'gallery', to: 'fragments#gallery', as: 'gallery'



  resources :collections do
    member do
      get :fragments_grid
    end
  end
  resources :collection_items, only: [:create, :destroy]

  resources :letters, only: [:update]

  devise_for :users
  
  resources :fragments do
    resource :likes, only: [:create, :destroy]
    resources :letters, only: [:new, :create]
    resources :colors, controller: 'fragment_colors', only: [:create, :destroy]
    get :timeline, on: :member
  end

  resources :comparisons, only: [:index, :update, :destroy] do
    collection do
      get 'select(/:fragment_id)', to: 'comparisons#select', as: :select
      get 'studio', to: 'comparisons#show', as: :studio
    end
    member do
      get :fragments_grid
    end
  end

  resources :rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :ideas, except: [:show] do
    resources :memos, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy, :update]
  resources :notifications, only: [:index]
  resources :memos, only: [:create, :destroy]
end
