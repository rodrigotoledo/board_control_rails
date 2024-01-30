Rails.application.routes.draw do
  resources :tasks, only: [:index, :update]
end
