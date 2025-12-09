Rails.application.routes.draw do 
  get "up" => "rails/health#show", as: :rails_health_check
  get 'focus/index'
  get '/@:username', to: 'users#show', as: :user_profile
  get 'notifications/index'
  root "fragments#index"
  get 'users/show'
  get 'focus', to: 'ideas#new', as: :focus_studio
  

  devise_for :users
  resources :fragments do
    resource :likes, only: [:create, :destroy]
  end

  resources :ideas, except: [:show] do
    resources :memos, only: [:create, :destroy]
  end
  
  resources :relationships, only: [:create, :destroy, :update]
  resources :notifications, only: [:index]
  resources :memos, only: [:create, :destroy]
end
