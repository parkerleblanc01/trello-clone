Rails.application.routes.draw do

  devise_for :users
  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Hard => '/sidekiq'
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "lists#index"

  resources :cards
  resources :lists
end
