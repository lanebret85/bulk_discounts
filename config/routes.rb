Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/merchants/:merchant_id/dashboard", to: "merchants#show"

  resources :merchants do
    resources :invoices, only: [:index, :show, :update]
    resources :invoice_items, only: [:update]
    resources :items
    resources :bulk_discounts, only: [:index, :show]
  end
  
  namespace :admin do
    resources :invoices, only: [:index, :show, :update]
    resources :merchants
  end

  resources :admin, only: [:index]
end
