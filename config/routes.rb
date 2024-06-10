Rails.application.routes.draw do
  devise_for :users

  resource :settings, only: [:show, :create]
  resource :owner_signup, only: [:show, :create], controller: :owner_signup
  # /stripe/webhook_events
  namespace :stripe do
    resource :account_sessions, only: [:create]
    resource :webhook_events, only: [:create]
  end

  # urls that use the listing id /listings
  # listings/my-house
  # listings/house-1/bookings/new
  resources :listings do
    get "photos", to: "listings#photos", on: :member
    scope module: :listings do
      # /listings/house-1/bookings/new
      resources :bookings, only: [:new, :create] do
        get "payment", to: "bookings#payment", on: :member
        get "success", to: "bookings#success", on: :member
        post "stripe_session", to: "bookings#stripe_session", on: :member
      end
    end
  end

  # urls that go after /listings
  # like /listings/file_uploads
  namespace :listings do
    resource :file_uploads, only: [:create]
  end

  # /bookings
  resources :bookings, only: [:index]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "listings#index"
end
