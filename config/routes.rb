Rails.application.routes.draw do
  resources :subscribers, only: [:index, :show]
  resources :subscriptions, only: [:index, :show, :create]
end
