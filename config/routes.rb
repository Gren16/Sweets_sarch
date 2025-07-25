Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#top"
  post "create_store", to: "static_pages#create_store"
  get "/stores/:id", to: "static_pages#show", as: "store"
  post "/directions", to: "directions#calculate_route"
  post "/fetch_routes", to: "routes#fetch_routes"
  resources :users, only: %i[new create]
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
  post "/static_pages/:id/bookmarks", to: "static_pages#add_bookmark"

  resources :stores
  resources :bookmarks, only: %i[create destroy]
  get "bookmarks", to: "static_pages#bookmarks", as: "bookmarks_stores"
  resources :routes, only: [ :new, :create, :show ] do
    collection do
      post :reset_session
    end
    member do
      delete :delete_route
    end
  end
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  resources :password_resets, only: %i[new create edit update]
  get "search_autocomplete", to: "static_pages#autocomplete"
end
