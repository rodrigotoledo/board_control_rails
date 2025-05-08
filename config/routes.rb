# frozen_string_literal: true

Rails.application.routes.draw do
  resources :projects
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: [ :new, :create ]
  root "home#index"
  namespace :api do
    namespace :v1 do
      resources :tasks, only: %i[index update] do
        collection do
          get "stats"
        end
      end
      resources :projects, only: %i[index update] do
        collection do
          get "stats"
        end
      end
    end

    namespace :v2 do
      resources :tasks, only: %i[index update show] do
        collection do
          get "stats"
        end

        member do
          put "mark_as_completed"
        end
      end
      resources :projects, only: %i[index update show] do
        collection do
          get "stats"
        end

        member do
          put "mark_as_completed"
        end
      end
    end
    resources :tasks, only: %i[index update]
    resources :projects, only: %i[index update]

    post "sign_up", to: "registrations#create", as: :sign_up
    post "sign_in", to: "sessions#create", as: :sign_in
    delete "logout", to: "sessions#destroy", as: :logout
  end
end
