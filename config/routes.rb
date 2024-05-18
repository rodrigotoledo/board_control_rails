Rails.application.routes.draw do
  namespace :api do
    resources :tasks, only: [:index, :update]
    resources :projects, only: [:index, :update]

    post 'sign_up', to: 'registrations#create', as: :sign_up
    post 'sign_in', to: 'sessions#create', as: :sign_in
    delete 'logout', to: 'sessions#destroy', as: :logout
  end
end
