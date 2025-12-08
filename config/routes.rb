Rails.application.routes.draw do 
  get 'notifications/index'
  root "fragments#index"
  get 'users/show'
  
  devise_for :users
  resources :fragments
  resources :relationships, only: [:create, :destroy, :update]
  resources :notifications, only: [:index]

  get '/@:username', to: 'users#show', as: :user_profile
  get "up" => "rails/health#show", as: :rails_health_check
end
