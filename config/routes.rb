Rails.application.routes.draw do 
  root "fragments#index"
  
  get 'users/show'
  devise_for :users
  resources :fragments
  get '/@:username', to: 'users#show', as: :user_profile

  get "up" => "rails/health#show", as: :rails_health_check
end
