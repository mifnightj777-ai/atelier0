Rails.application.routes.draw do 
  resources :fragments
  get "up" => "rails/health#show", as: :rails_health_check

  root "static_pages#top"

end
