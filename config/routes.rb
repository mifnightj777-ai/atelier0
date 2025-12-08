Rails.application.routes.draw do 
  get 'users/show'
  devise_for :users
  resources :fragments
  get '/@:username', to: 'users#show', as: :user_profile

  get "up" => "rails/health#show", as: :rails_health_check
  
  root "static_pages#top"

end
