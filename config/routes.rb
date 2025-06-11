Rails.application.routes.draw do
  get "notifications/index"
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  get "reports/sales"
  get "inventory/scan"
  resources :products
  get "dashboard/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "dashboard#index"
  resources :products do
    member do
      get :download_qr
      get :print_qr
    end
  end
  get 'inventory/scan', to: 'inventory#scan'
  post 'inventory/update_quantity', to: 'inventory#update_quantity'
  post 'inventory/sell', to: 'inventory#sell'
  get 'sales', to: 'sales#index'
  get 'reports/sales', to: 'reports#sales'
  resource :profile, only: [:show, :edit, :update]
  resources :notifications, only: [:index]


end
