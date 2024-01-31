Rails.application.routes.draw do
  resources :tasks, only: [:index, :update]
  resources :projects, only: [:index, :update]
end
