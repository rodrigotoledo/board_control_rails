# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :tasks, only: %i[index update]
    resources :projects, only: %i[index update]

    post 'sign_up', to: 'registrations#create', as: :sign_up
    post 'sign_in', to: 'sessions#create', as: :sign_in
    delete 'logout', to: 'sessions#destroy', as: :logout
  end
end
